class InstructionSendingMailer < ApplicationMailer
    #default from: "sacc.g13@gmail.com"

    def send_email(recipient_email, subject, content)
        @content = content
        mail(to: recipient_email, subject: subject)
    end
end
