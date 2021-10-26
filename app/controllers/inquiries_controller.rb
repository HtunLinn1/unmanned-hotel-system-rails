class InquiriesController < ApplicationController
  before_action :authenticate_user!
  before_action only: [:index, :show, :create] do
    staff_check
  end
  def index
    @inquiry = Inquiry.new
  end

  def show
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.user_id = current_user.id
    if @inquiry.save
      cus_name = current_user.name
      cus_email = current_user.email
      staff_email = 'staff1@gmail.com'
      staff_name = 'staff'
      title = Inquiry.last.title
      content = Inquiry.last.content
      mail_deliever = InquiryMailer.inquiry(cus_name, cus_email, staff_email, staff_name, title, content).deliver_now
      flash[:notice] = "メールを送信しました。!"
      Inquiry.last.destroy
      redirect_to inquiries_path
    else
      render("inquiries/show")
    end
  end

  private
  def staff_check
    redirect_to root_path if current_user.staff
    flash[:alert] = "お客様だけ！" if current_user.staff
  end

    def inquiry_params
      params.require(:inquiry).permit(:title, :content)
    end
end
