class SessionsController < ApplicationController
  REMEMBER_ME = "1".freeze
  def show
    @user = User.find_by(id: params[:id])
    return if @user

    redirect_to root_path, alert: t("sessions.show.user_not_found")
  end

  def create
    user = find_user_by_email
    if user&.authenticate(session_password)
<<<<<<< HEAD
      if user.activated?
        handle_successful_login(user)
      else
        flash[:warning] = t("sessions.create.account_not_activated")
        redirect_to root_url, status: :see_other
      end
=======
      handle_successful_login(user)
>>>>>>> b6ba749 (Chapter 10)
    else
      handle_failed_login
    end
  end

  private

  def find_user_by_email
    User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def session_password
    params.dig(:session, :password)
  end

  def handle_successful_login user
    forwarding_url = session[:forwarding_url]
    log_in user
    handle_remember_me(user)
    redirect_to forwarding_url || user
  end

  def handle_remember_me user
<<<<<<< HEAD
    if params.dig(:session, :remember_me) == REMEMBER_ME
=======
    if params.dig(:session, :remember_me) == "1"
>>>>>>> b6ba749 (Chapter 10)
      remember(user)
    else
      forget(user)
    end
  end

  def handle_failed_login
    flash.now[:danger] = t("sessions.create.invalid_email_or_password")
    render :new, status: :unprocessable_entity
  end
end
