class RefundMailer < ApplicationMailer
  layout 'mailer'

  def refund(cus_name, cus_email, staff_email, start_date, end_date, room_no, room_type, price, total_amount)
    @cus_name = cus_name
    @cus_email = cus_email
    @staff_email = staff_email
    @start_date = start_date
    @end_date = end_date
    @room_no = room_no
    @room_type = room_type
    @price = price
    @total_amount = total_amount
    mail_header = {
      to: cus_email,
      from: staff_email,
      subject: "#{cus_name}様に返金"
    }
    mail(mail_header)
  end
end
