require 'date'

class BookingsController < ApplicationController
  def index
    @booking = "booking"
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
    @booking.key = ''
    if @booking.save
      redirect_to("/bookings")
    else
      render("/bookings/new")
    end
  end

  private
    def booking_params
      params.require(:booking).permit(:credit_no, :room_id, :person_count, :start_date, :end_date, :total_amount)
    end
end
