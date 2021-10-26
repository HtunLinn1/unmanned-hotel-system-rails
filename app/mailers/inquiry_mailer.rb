class InquiryMailer < ApplicationMailer
  layout 'mailer'

  def inquiry(cus_name, cus_email, staff_email, staff_name, title, content)
    @cus_name = cus_name
    @cus_email = cus_email
    @staff_email = staff_email
    @staff_name = staff_name
    @title = title
    @content = content
    mail_header = {
      to: staff_email,
      from: cus_email,
      subject: "お問い合わせ"
    }
    mail(mail_header)
  end
end
