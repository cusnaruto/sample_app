class SessionsController < ApplicationController
  before_action :load_user, only: :show
  before_action :authenticate_user, only: :create

  def show; end

  # POST: /login
  def create
    reset_session
    log_in @user
    redirect_to session_path(@user), status: :see_other
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

  def authenticate_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user&.authenticate params.dig(:session, :password)

    flash.now[:danger] = t("sessions.create.invalid_email_or_password")
    render :new, status: :unprocessable_entity
  end
end
