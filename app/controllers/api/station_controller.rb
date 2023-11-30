module Api
    class StationController < ApplicationController

        skip_before_action :verify_authenticity_token
        before_action :get_station

        def get_report_deposit

            locker = params[:locker].to_i
            loc = @station.lockers.where(number:locker).first
            ord = loc.orders.where(state: 2).order(updated_at: :desc).first
            if ord
                ord.state = 3
                ord.delivery_time = Time.current
                ord.save
                message = "El casillero numero #{loc.number}, en la estacion #{@station.name} tiene su paquete.\n El codigo de retiro es: #{ord.retrieve_password}\n Instrucciones de apertura: Se tiene que escribir los seis numeros del codigo y se va abrir automaticamente, en caso de no funcionar, trate de presionar el símbolo # (usado para eliminar los caracteres) cinco veces y procede a escribir el codigo.\n Se va a encender la luz respectiva a su relación, abra la puerta numerada y retire el producto.\n Una vez terminado se cierra la puerta y se presiona el botón *."
                InstructionSendingMailer.send_email(ord.client_contact, 'Casillero reservado', message).deliver
            end
            if loc.state = 1

                loc.state = 2
                if loc.save
                    render json:{password: loc.codigo_r}
                end
            else
                render json:{password: "NoPass"}
            end

        end

        def get_report_retire

            locker = params[:locker].to_i
            loc = @station.lockers.where(number:locker).first
            ord = loc.orders.where(state: 3).order(updated_at: :desc).first
            if ord
                ord.state = 4
                ord.retrieve_time = Time.current
                ord.save
            end
            if loc.state == 2

                loc.state = 0
                loc.already_informed = 0
                loc.save

                render json:{status: "OK"}
            else
                render json:{status: "Fail"}
            end
        end

        def get_update
            lockers = @station.lockers

            if params.key?(:state)
                if @station.last_sensed != params[:state]
                    @station.last_sensed = params[:state]
                    @station.last_updated = Time.current
                    @station.save
                    partitions = params[:state].split(",")
                    for i in 0..2
                        lockers[i].sensors = partitions[i].to_i
                        lockers[i].save
                    end


                end
            end

            passwords = {}


            lockers.each do |l|
                order = l.orders.where(state: 1).order(created_at: :desc).first
                if order && l.already_informed == 0
                    pass = l.codigo_d
                    l.already_informed = 1
                    l.save
                    order.state = 2
                    order.save
                elsif l.estado == "Reservado" && l.already_informed == 0 && l.codigo_r != ""
                    pass = l.codigo_d
                    l.already_informed = 1
                    l.save
                else
                    pass = "000000"
                end
                passwords["password#{l.number}"] = pass
            end

            render json: passwords

        end

        private

        def get_station
            @station = LockerStation.find_by(access_key: params[:access_key])

            unless @station
              render json: { error: 'Locker station not found' }, status: :not_found
            end
        end
    end
end
