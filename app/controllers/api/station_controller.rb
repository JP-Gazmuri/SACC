module Api
    class StationController < ApplicationController
        
        skip_before_action :verify_authenticity_token
        before_action :get_station

        def get_report_deposit
            
            locker = params[:locker].to_i
            loc = @station.lockers.where(number:locker).first
            ord = loc.orders.last
            if not ord
                render json:{password: "NoPass"}
                return
            end
            if ord.state == 1
                loc.state = 2
                loc.save
                ord.state = 2
                ord.save
                message = "El casillero numero #{loc.number}, en la estacion #{@station.name} tiene su paquete.\n El codigo de retiro es: #{ord.retrieve_password}\n Instrucciones de apertura: Se tiene que escribir los seis numeros del codigo y se va abrir automaticamente, en caso de no funcionar, trate de presionar el símbolo # (usado para eliminar los caracteres) cinco veces y procede a escribir el codigo.\n Se va a encender la luz respectiva a su relación, abra la puerta numerada y retire el producto.\n Una vez terminado se cierra la puerta y se presiona el botón *."
                InstructionSendingMailer.send_email(ord.operator_contact, 'Casillero reservado', message).deliver

                render json:{password: ord.retrieve_password}
            else
                render json:{password: "NoPass"}
            end

        end

        def get_report_retire

            locker = params[:locker].to_i
            loc = @station.lockers.where(number:locker).first
            ord = loc.orders.last
            if not ord
                render json:{password: "NoPass"}
                return
            end
            if ord.state == 2
                loc.state = 0
                loc.save
                ord.state = 3
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
            
            password1 = "000000"
            password2 = "000000"
            password3 = "000000"
            
            locker = @station.lockers.where(number: 1).first
            ord = locker.orders.where(state: 0).last
            if ord
                ord.state = 1
                ord.save
                password1 = ord.deposit_password
            end

            locker = @station.lockers.where(number: 2).first
            ord = locker.orders.where(state: 0).last
            if ord
                ord.state = 1
                ord.save
                password2 = ord.deposit_password
            end

            locker = @station.lockers.where(number: 3).first
            ord = locker.orders.where(state: 0).last
            if ord
                ord.state = 1
                ord.save
                password3 = ord.deposit_password
            end
            render json: { password1: password1,password2: password2,password3: password3, }
        end        

        def report_deposit
        
            locker = params[:locker].to_i
            loc = @station.lockers.where(number:locker).first
            ord = loc.orders.last
            if ord.state == 1
                ord.state = 2
                ord.save
                render json:{password: ord.retrieve_password}
            else
                render json:{password: "NoPass"}
            end
        end

        def report_retire
            locker = params[:locker].to_i
            loc = @station.lockers.where(number:locker).first
            ord = loc.orders.last
            if ord.state == 2
                ord.state = 0
                ord.save
                render json:{status: "OK"}
            else
                render json:{status: "Fail"}
            end
        end

        def update
            password1 = "000000"
            password2 = "000000"
            password3 = "000000"
            locker = @station.lockers.where(number: 1).first
            ord = locker.orders.where(state: 0).first
            if ord
                ord.state = 1
                ord.save
                password1 = ord.deposit_password
            end

            locker = @station.lockers.where(number: 2).first
            ord = locker.orders.where(state: 0).first
            if ord
                ord.state = 1
                ord.save
                password2 = ord.deposit_password
            end

            locker = @station.lockers.where(number: 3).first
            ord = locker.orders.where(state: 0).first
            if ord
                ord.state = 1
                ord.save
                password3 = ord.deposit_password
            end
            render json: { password1: password1,password2: password2,password3: password3, }
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