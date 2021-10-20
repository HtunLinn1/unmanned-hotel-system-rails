class RoomsController < ApplicationController
  before_action :authenticate_user!,　only: [:create, :edit, :update, :destroy]
  before_action only: [:create, :new, :edit, :update, :destroy] do
    staff_check
  end

  def index
    @rooms = Room.all
    if params[:startdate] && params[:enddate]
      @booking = true
      @startdate = params[:startdate]
      @enddate = params[:enddate]
      @people = params[:people].to_i
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
      redirect_to("/rooms/#{@room.id}")
    else
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
      redirect_to("/rooms/#{@room.id}")
    else
      flash.now[:alert] = "更新失敗！"
      render("rooms/edit")
    end
  end

  def staff_check
    redirect_to root_path unless current_user.staff
    flash[:notice] = "ホテルの社員だけできる！" unless current_user.staff
  end

  private
    def room_params
      params.require(:room).permit(:room_type, :room_no, :price, :limit_person, :image)
    end
end
