class InstructionSendingMailer < ApplicationMailer
    default from: "jpgazmuri@miuandes.cl"

    def send_email(recipient_email, subject, content)
        @content = content
        mail(to: recipient_email, subject: subject)
    end
end
