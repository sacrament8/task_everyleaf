class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i(have_tasks edit update destroy)
  before_action :not_enter_no_Sign_in_user
  before_action :not_enter_no_admin_user

  def index
    @users = User.includes(:tasks).order(created_at: 'DESC').page(params[:page])
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  # ログインユーザーでなければログイン画面に飛ばしてフラッシュを表示
  def not_enter_no_Sign_in_user
    unless current_user
      redirect_to new_session_path, notice: "ログインしてください" 
      return
    end
  end

  # カレントユーザーが管理者じゃなければ個人ページに転送してフラッシュを表示
  def not_enter_no_admin_user
    unless current_user.admin?
      trigger_not_admin_user_error
    end
  end

  # 自作例外NotAdminUserをトリガする
  def trigger_not_admin_user_error
    raise NotAdminUser
  end

end