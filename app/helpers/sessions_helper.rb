module SessionsHelper

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def your_task_over_deadline?
    (current_user.expired.present? || current_user.one_day_left.present?) ? true : false
  end
  
end