require 'date'

class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action only: [:show] do
    staff_check
  end
  before_action only: [:new, :create] do
    customer_check
  end
  def index
    Booking.where("end_date < ?", Date.today).update_all(check_out:true, key:'*****', credit_no: '***************')
    if current_user.staff
      if params[:status] == 'cancel'
        @bookings = Booking.where(cancle: true).page(params[:page]).per(5).order('start_date ASC')
      elsif params[:status] == 'notpaid'
        @bookings = Booking.where(paied: false).page(params[:page]).per(5).order('start_date ASC')
      else
        @bookings = Booking.where(check_out: false).page(params[:page]).per(5).order('start_date ASC')
      end
      @cancel_count = Booking.where(cancle: true).count
      @nopaid_count = Booking.where(paied: false).count
    else
      user = User.find_by_id(current_user.id)
      @bookings = user.bookings.page(params[:page]).per(5).order('start_date ASC')
    end
  end

  def show
    @bookings = Booking.where(check_out: true).page(params[:page]).per(5).order('start_date ASC')
  end
  
  def historyDelete
    @booking = Booking.find(params[:id])
    @booking.destroy
    flash[:notice] = "削除成功!"
    redirect_to bookings_history_url
  end

  def new
    @room = Room.find_by_id(params[:room_id])
    @startdate = params[:startdate]
    @enddate = params[:enddate]
    @people = params[:people]

    if @room.limit_person < params[:people].to_i
      flash[:notice] = "部屋の定員より超えています。!"
      redirect_to rooms_url(:startdate => params[:startdate], :enddate => params[:enddate], :people => params[:people])
    end

    if @enddate < @startdate
      flash[:notice] = "#{@startdate}チェックイン日付は#{@enddate}チェックアウト日付より超えています!"
      redirect_to root_path
    end

    @room.bookings.each do |booking|
      if (booking.start_date <= @startdate && @startdate <= booking.end_date) ||
         (booking.start_date <= @enddate && @enddate <= booking.end_date) ||
         (@startdate <= booking.start_date && booking.end_date <= @enddate  )

        flash[:notice] = "#{@startdate}と#{@enddate}間に選んだ部屋は予約できないです!"
        redirect_to root_path
      end
    end

    @booking = Booking.new
    date_count = (@enddate.to_date - @startdate.to_date).to_i
    @total_amount = date_count * @room.price
  end

  def create
    @room = Room.find_by_id(params[:booking][:room_id])
    @startdate = params[:booking][:start_date]
    @enddate = params[:booking][:end_date]
    @people = params[:booking][:person_count]
    @booking = Booking.new(booking_params)
    date_count = (@enddate.to_date - @startdate.to_date).to_i
    @total_amount = date_count * @room.price

    @booking = Booking.new(booking_params)
    @booking.user_id = current_user.id
    @booking.check_out = false
    @booking.paied = false
    @booking.cancle = false
    @booking.packing = false
    @booking.key = '*****'
    if @booking.save
      # channel message
      nopaid_count = Booking.where(paied: false).count
      ActionCable.server.broadcast 'message_channel', nopaid_count: nopaid_count

      flash[:notice] = "予約成功しました!"
      redirect_to("/bookings")
    else
      flash[:alert] = "予約失敗しました!"
      render("/bookings/new")
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    # channel message
    nopaid_count = Booking.where(paied: false).count
    ActionCable.server.broadcast 'message_channel', nopaid_count: nopaid_count
    
    flash[:notice] = "成功しました!"
    redirect_to bookings_url
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
      # channel message
      change_credit = 'change-credit'
      ActionCable.server.broadcast 'message_channel', change_credit: change_credit

      flash[:notice] = "更新成功！"
      redirect_to("/bookings")
    else
      render("bookings/edit")
    end
  end

  def paid
    key_no = rand(1000..9999)
    key_no = key_no.to_s + '*'
    booking_id = params[:id]
    booking_update = Booking.where(id:booking_id).update_all(paied:true, key:key_no)

    booking = Booking.find_by_id(booking_id)
    cus_name = booking.user.name
    cus_email = booking.user.email
    staff_email = current_user.email
    start_date = booking.start_date
    end_date = booking.end_date
    room_no = booking.room.room_no
    room_type = booking.room.room_type
    price = booking.room.price
    total_amount = booking.total_amount
    key_no = key_no

    if booking_update
      flash[:notice] = "支払成功！"
      mail_deliever = PaymentMailer.payment(cus_name, cus_email, staff_email, start_date, end_date, room_no, room_type, price, total_amount, key_no).deliver_now
      redirect_to("/bookings")
    else
      flash[:alert] = "支払失敗"
      redirect_to("/bookings")
    end
  end

  def cancel
    cancel = Booking.where(id:params[:id]).update_all(cancle:true)
    if cancel
      # channel message
      cancel_count = Booking.where(cancle: true).count
      ActionCable.server.broadcast 'message_channel', cancel_count: cancel_count
      redirect_to("/bookings")
    else
      flash[:alert] = "キャンセル失敗"
      redirect_to("/bookings")
    end
  end

  def refund
    booking = Booking.find(params[:id])
    cus_name = booking.user.name
    cus_email = booking.user.email
    staff_email = current_user.email
    start_date = booking.start_date
    end_date = booking.end_date
    room_no = booking.room.room_no
    room_type = booking.room.room_type
    price = booking.room.price
    total_amount = booking.total_amount
    booking.destroy
    mail_deliever = RefundMailer.refund(cus_name, cus_email, staff_email, start_date, end_date, room_no, room_type, price, total_amount).deliver_now
    flash[:notice] = "返金成功!"
    redirect_to bookings_url
  end

  private
    def staff_check
      redirect_to root_path unless current_user.staff
      flash[:notice] = "ホテルの社員だけできる！" unless current_user.staff
    end
  
    def customer_check
      redirect_to root_path if current_user.staff
      flash[:notice] = "お客様の社員だけできる！" if current_user.staff
    end

    def booking_params
      params.require(:booking).permit(:credit_no, :room_id, :person_count, :start_date, :end_date, :total_amount)
    end
end
