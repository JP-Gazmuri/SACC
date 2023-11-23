module Api
    class EcommerceController < ApplicationController

        skip_before_action :verify_authenticity_token
        before_action :check_key

        require 'securerandom'

        def generate_random_number_string
            random_number = SecureRandom.random_number(10**6)
            formatted_number = format('%06d', random_number)
            formatted_number
        end

        def available_lockers

            @lockers = Locker.where(state: 0)

            # Organize your data into a hash
            locker_data = {}
            @lockers.each do |locker|
              locker_data[locker.id] = {
                estacion: locker.locker_station.name,
                numero: locker.number,
                length: locker.length,
                width: locker.width,
                height: locker.height
              }
            end

            render json: locker_data

        end

        def reserve_locker

            required_params = ['station', 'access_key', 'height','width','length','client_email','operator_email']

            if not required_params.all? { |param| params.key?(param) }
                render json: { result: "Faltan parametros, los parametros necesarios son: 'station', 'access_key', 'height','width','length','client_email','operator_email'" }
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
                    ord.operator_contact = params[:operator_email]
                    ord.ecommerce = @ecommerce
                    ord.deposit_password = generate_random_number_string
                    ord.retrieve_password = generate_random_number_string
                    ord.height = params[:height].to_i
                    ord.width = params[:width].to_i
                    ord.length = params[:length].to_i
                    if ord.save
                        smallest_locker.state = 1
                        smallest_locker.save
                        message = "El casillero numero #{smallest_locker.number}, en la estacion #{station.name} esta esperando la entrega. El codigo de deposito es: #{ord.deposit_password}.\n Instrucciones de apertura: Se tiene que escribir los seis numeros del codigo y se va abrir automaticamente, en caso de no funcionar, trate de presionar el símbolo # (usado para eliminar los caracteres) cinco veces y procede a escribir el codigo.\n Se va a encender la luz respectiva a su relación, abra la puerta numerada y deposite el producto.\n Una vez terminado se cierra la puerta y se presiona el botón *."
                        InstructionSendingMailer.send_email(ord.operator_contact, 'Casillero reservado', message).deliver

                        render json:{result: "Casillero reservado"}
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

        end

        def cancel_order

        end

        def active_orders

        end

        def historic_orders

        end

        private

        def check_key
            @ecommerce = Ecommerce.find_by(key: params[:access_key])

            unless @ecommerce
              render json: { error: 'Llave de acceso no existe' }, status: :not_found
            end

        end

    end
end
