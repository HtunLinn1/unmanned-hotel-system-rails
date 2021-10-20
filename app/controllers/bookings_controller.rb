require 'date'

class BookingsController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.staff
      @bookings = Booking.where("end_date >= ?", Date.today).page(params[:page]).per(5).order('start_date ASC')
    else
      user = User.find_by_id(current_user.id)
      @bookings = user.bookings.page(params[:page]).per(5).order('start_date ASC')
    end
  end

  def show
    @bookings = Booking.where("end_date < ?", Date.today).page(params[:page]).per(5).order('start_date ASC')
  end

  def new
    @room = Room.find_by_id(params[:room_id])
    @booking = Booking.new
    @startdate = params[:startdate]
    @enddate = params[:enddate]
    @people = params[:people]
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
    flash[:notice] = "成功しました!"
    redirect_to bookings_url
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
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
    key_no = key_no

    if booking_update
      flash[:notice] = "支払い成功！"
      mail_deliever = PaymentMailer.payment(cus_name, cus_email, staff_email, key_no).deliver_now
      redirect_to("/bookings")
    else
      flash[:alert] = "支払い失敗"
      redirect_to("/bookings")
    end
  end

  def cancel
    cancel = Booking.where(id:params[:id]).update_all(cancle:true)
    if cancel
      redirect_to("/bookings")
    else
      flash[:alert] = "キャンセル失敗"
      redirect_to("/bookings")
    end
  end

  private
    def booking_params
      params.require(:booking).permit(:credit_no, :room_id, :person_count, :start_date, :end_date, :total_amount)
    end
end
