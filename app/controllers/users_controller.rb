class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
    else
      render :new
    end
  end
end
