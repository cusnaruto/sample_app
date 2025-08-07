class UsersController < ApplicationController
  include Pagy::Backend

  before_action :load_user,
                only: %i(show edit update destroy following followers)
  before_action :logged_in_user,
                only: %i(index edit update destroy following followers)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy

  def show
    @page, @microposts = pagy @user.microposts, items: Settings.page_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = t(".welcome")
      redirect_to root_url, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  # PATCH/PUT: /users/:id
  def update
    if @user.update user_params
      flash[:success] = t("users.update.success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET: /users
  def index
    @pagy, @users = pagy User.newest_first, items: Settings.page_10
  end

  # DELETE: /users/:id
  def destroy
    if @user.destroy
      flash[:success] = t("users.destroy.success")
    else
      flash[:danger] = t("users.destroy.fail")
    end
    redirect_to users_path
  end

  def following
    @title = t("users.show_follow.following")
    @pagy, @users = pagy(@user.following, items: Settings.pagy.items)
    render "show_follow"
  end

  def followers
    @title = t("users.show_follow.followers")
    @pagy, @users = pagy(@user.followers, items: Settings.pagy.items)
    render "show_follow"
  end

  private
  def user_params
    params.require(:user).permit(User::USER_PERMIT_PARAMS)
  end

  def admin_user
    return if current_user.admin?

    redirect_to root_path
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("users.not_found")
    redirect_to root_path
  end

  def correct_user
    return if current_user?(@user) || current_user.admin?

    flash[:error] = t("users.not_correct")
    redirect_to root_path
  end
end
