class RoomsController < ApplicationController
  before_action :authenticate_user!,　only: [:create, :edit, :update, :destroy]
  before_action only: [:create, :new, :edit, :update, :destroy] do
    staff_check
  end

  def index
    @booked_roomids = []
    @rooms = Room.all.order('room_no ASC')
    if params[:startdate] && params[:enddate]
      @booking = true
      @startdate = params[:startdate]
      @enddate = params[:enddate]
      @people = params[:people].to_i

      @rooms.each do |room|
        room.bookings.each do |booking|
          if (booking.start_date <= @startdate && @startdate < booking.end_date) ||
             (booking.start_date <= @enddate && @enddate <= booking.end_date) ||
             (@startdate <= booking.start_date && booking.end_date <= @enddate  )
            @booked_roomids << room.id
          end
        end
      end
    else
      @booking = false
    end
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      flash.now[:notice] = "作成成功！"
      redirect_to("/rooms/#{@room.id}")
    else
      flash.now[:notice] = "更新失敗！"
      render("rooms/new")
    end
  end

  def show
    @room = Room.find_by_id(params[:id])
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:notice] = "削除成功!"
    redirect_to rooms_url
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update(room_params)
      flash.now[:notice] = "更新成功！"
      redirect_to("/rooms/#{@room.id}")
    else
      flash.now[:alert] = "更新失敗！"
      render("rooms/edit")
    end
  end

  private
    def staff_check
      redirect_to root_path unless current_user.staff
      flash[:notice] = "ホテルの社員だけできる！" unless current_user.staff
    end

    def room_params
      params.require(:room).permit(:room_type, :room_no, :price, :limit_person, :image)
    end
end
