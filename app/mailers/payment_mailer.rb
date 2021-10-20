class PaymentMailer < ApplicationMailer
  layout 'mailer'

  def payment(cus_name, cus_email, staff_email, key_no)
    @cus_name = cus_name
    @cus_email = cus_email
    @staff_email = staff_email
    @key_no = key_no
    mail_header = {
      to: cus_email,
      from: staff_email,
      subject: "#{cus_name}様の鍵番号"
    }
    mail(mail_header)
  end
end
