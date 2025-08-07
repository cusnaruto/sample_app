class SessionsController < ApplicationController
  REMEMBER_ME = "1".freeze

  before_action :load_user, only: :show
  before_action :find_and_authenticate_user, only: :create

  def show; end

  # POST: /login
  def create
    if user_activated?
      handle_successful_login
    else
      handle_unactivated_account
    end
  end

  # DELETE: /logout
  def destroy
    log_out if logged_in?
    redirect_to root_path, status: :see_other,
    notice: t("sessions.destroy.logged_out")
  end

  private

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    redirect_to root_path, alert: t("sessions.show.user_not_found")
  end

  def find_and_authenticate_user
    @user = User.find_by(email: session_email)
    return if @user&.authenticate(session_password)

    flash.now[:danger] = t("sessions.create.invalid_email_or_password")
    render :new, status: :unprocessable_entity
  end

  def session_email
    params.dig(:session, :email)&.downcase
  end

  def session_password
    params.dig(:session, :password)
  end

  def user_activated?
    @user.activated?
  end

  def handle_successful_login
    log_in @user
    handle_remember_me
    redirect_back_or @user
  end

  def handle_unactivated_account
    flash[:warning] = t("sessions.create.account_not_activated")
    redirect_to root_url
  end

  def handle_remember_me
    if params.dig(:session,
                  :remember_me) == REMEMBER_ME
      remember(@user)
    else
      forget(@user)
    end
  end
end
