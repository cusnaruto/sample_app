module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    reset_session

    @current_user = nil
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
