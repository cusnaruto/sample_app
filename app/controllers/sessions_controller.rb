class SessionsController < ApplicationController
  REMEMBER_ME_CONST = "1"

  before_action :load_user, only: :show
  before_action :find_user_by_email, only: :create
  before_action :authenticate_user, only: :create

  def show; end

  def new; end

  def create
    handle_successful_authentication(@user)
  end

  private

  def find_user_by_email
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash.now[:danger] = t("sessions.create.user_not_found")
    render :new, status: :unprocessable_entity
  end

  def authenticate_user
    return if @user&.authenticate(params.dig(:session, :password))

    handle_failed_authentication
  end

  def handle_successful_authentication(user)
    log_in user
    params.dig(:session, :remember_me) == REMEMBER_ME_CONST ? remember(user) : forget(user)
    redirect_to session_path(user), status: :see_other
  end

  def handle_failed_authentication
    flash.now[:danger] = t("sessions.create.invalid_email_or_password")
    render :new, status: :unprocessable_entity
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    redirect_to root_path, alert: t("sessions.show.user_not_found")
  end
end
