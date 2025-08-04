class AccountActivationsController < ApplicationController
  before_action :load_user, :check_user_exists
  before_action :check_already_activated
  before_action :check_authentication

  # GET: /account_activations/:id/edit
  def edit
    @user.activate
    log_in @user
    flash[:success] = t("account_activations.edit.success")
    redirect_to @user
  end

  private

  def load_user
    return if @user = User.find_by(email: params[:email])

    flash[:danger] = t("account_activations.edit.user_not_found")
    redirect_to root_url
  end

  def check_already_activated
    return unless @user&.activated?

    flash[:info] = t("account_activations.edit.already_activated")
    redirect_to root_url
  end

  def check_authentication
    return if @user&.authenticated?(:activation, params[:id])

    flash[:danger] = t("account_activations.edit.invalid_token")
    redirect_to root_url
  end
end
