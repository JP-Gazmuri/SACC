module Api
    class EcommerceController < ApplicationController

        skip_before_action :verify_authenticity_token
        before_action :check_key
        before_action :cancel_late_orders
        before_action :update_lockers, only: [:available_lockers, :reserve_locker,:confirm_order]

        require 'active_support/time'
        require 'securerandom'
        require 'net/http'
        require 'uri'
        require 'httparty'
        require 'json'

        ROUTES = {G11:{lockers:"", logs:""},G14:{lockers: "https://pds3.vercel.app/estaciones/id/casilleros", logs:"https://pds3.vercel.app/api/logs"}}

        def generate_random_number_string
            random_number = SecureRandom.random_number(10**6)
            formatted_number = format('%06d', random_number)
            formatted_number
        end

        def available_lockers


            @stations = LockerStation.where(state: 0).all

            locker_data = {}
            @stations.each do |s|
                lockers = s.lockers.where(state: 0).order(:number)

                locker_data[s.name] = {}
                lockers.each do |locker|
                    locker_data[s.name][locker.id] = {
                        estacion: locker.locker_station.name,
                        numero: locker.number,
                        largo: locker.largo,
                        ancho: locker.ancho,
                        altura: locker.alto
                    }
                end
            end

            render json: locker_data

        end

        def reserve_locker

            required_params = ['station', 'access_key', 'height','width','length','client_email']

            if not required_params.all? { |param| params.key?(param) }
                render json: { result: "Faltan parametros, los parametros necesarios son: 'access_key', 'station', 'height','width','length','client_email'" }
                return
            end

            object_dimensions = {
              length: params[:length].to_i,
              width: params[:width].to_i,
              height: params[:height].to_i
            }

            station = LockerStation.find_by(name: params[:station])



            if station

                smallest_locker = Locker.find_smallest_locker(object_dimensions,station)

                if smallest_locker
                    ord = Order.new
                    ord.locker = smallest_locker
                    ord.state = 0
                    ord.client_contact = params[:client_email]
                    ord.ecommerce = @ecommerce
                    ord.deposit_password = generate_random_number_string
                    ord.retrieve_password = generate_random_number_string
                    ord.height = params[:height].to_i
                    ord.width = params[:width].to_i
                    ord.length = params[:length].to_i
                    if ord.save
                        smallest_locker.state = 1
                        smallest_locker.codigo_r = ord.retrieve_password
                        smallest_locker.codigo_d = ord.deposit_password
                        smallest_locker.save

                        if station.name == "G14"

                        end

                        render json:{result: "Casillero reservado, id del pedido: #{ord.id}"}
                        return
                    end

                else
                    render json: { result: "No hay un casillero con las dimensiones suficientes" }
                    return
                end

            else
                render json: { result: "No hay una estación de casilleros con ese nombre" }
                return
            end

        end

        def confirm_order
            # Obtener una orden de la URL
            order = Order.find(params[:order_id])

            if order.state != "reservado"
                render json: {result: "La reserva fue denegada porque hubo un problema con el id de la orden entregado. Posibles razones: cancelación automática por tiempo en reserva, equivocacion en la entrega a confirmar"}
                return
            end

            # Cambiar el estado de la orden a 1
            order.state = 1

            # Agregar operator_contact a la orden
            order.operator_contact = params[:operator_contact]

            if params[:height] && params[:width] && params[:length]
                # Verificar si las dimensiones caben en el locker ya definido en la orden como orden.locker
                if order.locker.height >= params[:height].to_i && order.locker.width >= params[:width].to_i && order.locker.length >= params[:length].to_i
                    order.alto = params[:height].to_i
                    order.ancho = params[:width].to_i
                    order.largo = params[:length].to_i
                else
                    # Verificar si las dimensiones caben en un locker más pequeño
                    new_locker = Locker.find_smallest_locker({ height: params[:height].to_i, width: params[:width].to_i, length: params[:length].to_i }, order.locker.locker_station)
                    if new_locker
                        order.locker = new_locker
                        order.alto = params[:height].to_i
                        order.ancho = params[:width].to_i
                        order.largo = params[:length].to_i
                    else
                        # Si no hay lockers disponibles, cambiar el estado de la orden a cancelado y proporcionar un mensaje en el JSON que explique que no se pudo confirmar la reserva porque no hay casillero con las dimensiones
                        order.state = "cancelado"
                        render json: { message: "No se pudo confirmar la reserva porque no hay casillero con las dimensiones solicitadas." }
                        return
                    end
                end
            end

            # Guardar los cambios en la orden
            order.save!

            # Devolver la orden actualizada como JSON
            render json: order
        end

        def cancel_order
            # Obtener una orden de la URL
            order = Order.find(params[:order_id])

            # Cambiar el estado de la orden a 1
            order.state = 4

            order.save!
        end

        def active_orders
            # Obtener todas las órdenes que estén activas
            orders = @ecommerce.orders.where.not(state: [3, 4])

            # Devolver las órdenes como JSON
            render json: orders
        end

        def historic_orders
            orders = @ecommerce.orders.where(state: 3)
            # Devolver las órdenes como JSON
            render json: orders
        end

        def order_state
            order = @ecommerce.orders.find(params[:order_id])
            render json: order.state
        end


        private


        def update_lockers
            stations = LockerStation.all

            stations.each do |station|
                if station.name != "G13"
                    response = HTTParty.get(ROUTES[station.name.to_sym][:lockers])

                    # Access the response data
                    response_code = response.code
                    response_body = response.body
                    json_data = JSON.parse(response_body)
                    lockers = station.lockers
                    lockers.each do |locker|
                        if locker.estado != json_data["data"][locker.number-1]["estado"]
                            locker.estado = json_data["data"][locker.number-1]["estado"]
                            locker.save
                        end
                    end
                end
            end
        end

        def cancel_late_orders
            time_threshold = 10.minutes.ago
            orders = Order.where(state: 0).where('created_at < ?', time_threshold)
            orders.each do |order|

                order.state = 5
                order.save
                l = Locker.find(order.locker_id)
                l.state = 0
                l.save
            end
        end


        def check_key
            @ecommerce = Ecommerce.find_by(key: params[:access_key])

            unless @ecommerce
              render json: { error: 'Llave de acceso no existe' }, status: :not_found
            end

        end

    end
end
