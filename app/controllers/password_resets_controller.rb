class PasswordResetsController < ApplicationController
  PASSWORD_RESET_PERMIT_PARAMS = %i(password password_confirmation).freeze

  before_action :load_user_by_email, only: :create
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)
  before_action :check_empty_password, only: :update

  # GET: /password_resets/new
  def new; end

  # PUT: /password_resets/:id/edit
  def edit; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t("password_resets.email_sent")
    redirect_to root_url
  end

  def update
    if @user.update(user_params.merge(reset_digest: nil))
      log_in @user
      UserMailer.password_reset_confirmation(@user).deliver_now
      flash[:success] = t("password_resets.password_reset_success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(*PASSWORD_RESET_PERMIT_PARAMS)
  end

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t("password_resets.user_not_found")
    redirect_to root_url
  end

  def valid_user
    return if @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t("password_resets.invalid_user")
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("password_resets.link_expired")
    redirect_to new_password_reset_url
  end

  def load_user_by_email
    email = params.dig(:password_reset, :email)&.downcase
    @user = User.find_by(email:)
    return if @user

    flash.now[:danger] = t("password_resets.email_not_found")
    render :new, status: :unprocessable_entity
  end

  def check_empty_password
    return unless params.dig(:user, :password).to_s.empty?

    @user ||= User.find_by(email: params[:email])
    @user&.errors&.add(:password, t("password_resets.password_blank"))
    render :edit, status: :unprocessable_entity
  end
end
