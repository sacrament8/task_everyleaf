class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      if your_task_over_deadline?
        flash[:danger] = '終了期限を過ぎたタスク、または終了期限が1日過ぎたタスクがあります'
        redirect_to expired_tasks_url
      else
        redirect_to user_url(user.id), notice: "ログインに成功しました"
      end
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to new_session_path, notice: "ログアウトしました"
  end

 

end