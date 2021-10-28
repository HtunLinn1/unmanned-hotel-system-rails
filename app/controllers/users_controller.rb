class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action only: [:edit, :update, :destroy] do
    staff_check
  end
  before_action only: [:show, :edit, :update, :destroy] do
    login_user_check
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update(user_params)
      flash.now[:notice] = "更新成功！"
      redirect_to("/users/#{@user.id}")
    else
      flash.now[:alert] = "更新失敗！"
      render("users/edit")
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    # channel message
    user_delete = 'user-delete'
    ActionCable.server.broadcast 'message_channel', user_delete: user_delete

    flash[:notice] = "削除成功!"
    redirect_to user_session_url
  end

  private
    def staff_check
      redirect_to root_path if current_user.staff
      flash[:notice] = "スタッフはできません！" if current_user.staff
    end

    def login_user_check
      if params[:id] && current_user.id != params[:id].to_i
        redirect_to root_url 
        flash[:notice] = "ログインユーザーじゃない！"
      end
    end

    def user_params
      params.require(:user).permit(:name, :email, :phone, :picture)
    end
end
