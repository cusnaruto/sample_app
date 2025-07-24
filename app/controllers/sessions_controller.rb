class SessionsController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    return if @user

    redirect_to root_path, alert: t("sessions.show.user_not_found")
  end

  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)
    if user&.authenticate params.dig(:session, :password)
      reset_session
      log_in user
      redirect_to session_path(user), status: :see_other
    else
      flash.now[:danger] = t("sessions.create.invalid_email_or_password")
      render :new, status: :unprocessable_entity
    end
  end
end
