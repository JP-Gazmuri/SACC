module Api
    class StationController < ApplicationController

        skip_before_action :verify_authenticity_token
        before_action :get_station

        def get_report_deposit

            locker = params[:locker].to_i
            loc = @station.lockers.where(number:locker).first
            ord = loc.orders.where(state: 2).order(modified_at: :desc).first
            if not ord
                render json:{password: "NoPass"}
                return
            end
            if ord
                loc.state = 2
                loc.save
                ord.state = 3
                ord.save
                message = "El casillero numero #{loc.number}, en la estacion #{@station.name} tiene su paquete.\n El codigo de retiro es: #{ord.retrieve_password}\n Instrucciones de apertura: Se tiene que escribir los seis numeros del codigo y se va abrir automaticamente, en caso de no funcionar, trate de presionar el símbolo # (usado para eliminar los caracteres) cinco veces y procede a escribir el codigo.\n Se va a encender la luz respectiva a su relación, abra la puerta numerada y retire el producto.\n Una vez terminado se cierra la puerta y se presiona el botón *."
                InstructionSendingMailer.send_email(ord.client_contact, 'Casillero reservado', message).deliver

                render json:{password: ord.retrieve_password}
            else
                render json:{password: "NoPass"}
            end

        end

        def get_report_retire

            locker = params[:locker].to_i
            loc = @station.lockers.where(number:locker).first
            ord = loc.orders.where(state: 3).order(modified_at: :desc).first
            if not ord
                render json:{status: "Fail"}
                return
            end
            if ord
                loc.state = 0
                loc.save
                ord.state = 4
                ord.save
                render json:{status: "OK"}
            else
                render json:{status: "Fail"}
            end
        end

        def get_update

            if params.key?(:state)
                @station.last_sensed = params[:state]
                @station.last_updated = Time.current
                @station.save
            end

            passwords = {}

            lockers = @station.lockers

            lockers.each do |l|
                order = l.orders.where(state: 1).order(created_at: :desc).first
                if order
                    pass = order.deposit_password
                    order.state = 2
                    order.save
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
