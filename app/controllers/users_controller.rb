class UsersController < ApplicationController
  before_action :set_user, only: %i(show)
  
  def new
    if current_user
      flash[:danger] = "あなたは既に登録ユーザーです"
      redirect_to user_path(current_user)
      return
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to user_path(@user), notice: 'ユーザー登録に成功したので、ログインしました'
    else
      flash.now[:danger] = "ユーザー登録できませんでした、入力に不備があります"
      render :new
    end
  end

  def show
    unless current_user.id == params[:id].to_i
      flash[:danger] = "自分以外のユーザーページはご覧いただけません"
      redirect_to user_path(current_user)
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  def set_user
    @user = User.find(params[:id])
  end
end