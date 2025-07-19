class ApplicationController < ActionController::Base
  def signup
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render "signup"
    end
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :dob, :password,
                                 :password_confirmation)
  end
end
