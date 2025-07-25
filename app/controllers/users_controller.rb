class UsersController < ApplicationController
  USER_PERMIT = %i(name email dob gender password password_confirmation).freeze

  before_action :load_user, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t(".welcome")
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t(".user_not_found")
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(*USER_PERMIT)
  end
end
