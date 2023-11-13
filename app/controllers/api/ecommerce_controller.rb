module Api
    class EcommerceController < ApplicationController
        skip_before_action :verify_authenticity_token

        def available_lockers

        end

        def reserve_locker

            mail = params[:email]

            InstructionSendingMailer.send_email(mail, 'Casillero reservado', 'Test email that will be customized in the future').deliver

            render json:{result: "Finished"}

        end

        def confirm_order
            
        end
        
        def cancel_order

        end

        def active_orders
        
        end

        def historic_orders
        
        end

        

    end
end
  