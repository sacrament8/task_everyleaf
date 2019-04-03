class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i(have_tasks edit update destroy)

  def index
    @users = User.all.order(created_at: 'DESC').page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "ユーザー「#{ @user.name }」を登録しました"
    else
      flash.now[:danger] = '入力に不備があります、入力欄を確認してください'
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザー「#{ @user.name }」の情報を更新しました"
    else
      flash.now[:danger] = '入力に不備があります、入力欄を確認してください'
      render :edit
    end
  end

  def have_tasks
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザー「#{ @user.name }」を削除しました"
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end