class UsersController < ApplicationController
  include Pagy::Backend

  before_action :load_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    @page, @microposts = pagy(@user.microposts.recent_posts, items: Settings.pagy.limit)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        @user.send_activation_email

        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("users.update.success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @pagy, @users = pagy User.all, items: Settings.page_10
  end

  def destroy
    if @user.destroy
      flash[:success] = t("users.destroy.success")
    else
      flash[:danger] = t("users.destroy.fail")
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(User::USER_PERMIT_PARAMS)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("users.not_found")
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("users.login_required")
    redirect_to login_path
  end

  def correct_user
    return if current_user?(@user) || current_user.admin?

    flash[:error] = t("users.not_correct")
    redirect_to root_path
  end
end
