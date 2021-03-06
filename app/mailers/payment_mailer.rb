class PaymentMailer < ApplicationMailer
  layout 'mailer'

  def payment(cus_name, cus_email, staff_email, start_date, end_date, room_no, room_type, price, total_amount, key_no)
    @cus_name = cus_name
    @cus_email = cus_email
    @staff_email = staff_email
    @start_date = start_date
    @end_date = end_date
    @room_no = room_no
    @room_type = room_type
    @price = price
    @total_amount = total_amount
    @key_no = key_no
    mail_header = {
      to: cus_email,
      from: staff_email,
      subject: "#{cus_name}様の暗証番号"
    }
    mail(mail_header)
  end
end
