class UsersController < ApplicationController
  include Pagy::Backend

  before_action :load_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy

  def show; end

<<<<<<< HEAD
<<<<<<< HEAD
  # GET: /users/new
=======
>>>>>>> b6ba749 (Chapter 10)
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t(".welcome")
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
=======
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        @user.send_activation_email

        format.html do
          redirect_to user_url(@user),
                      notice: "User was successfully created."
        end
        format.json{render :show, status: :created, location: @user}
      else
        format.html{render :new, status: :unprocessable_entity}
        format.json{render json: @user.errors, status: :unprocessable_entity}
      end
>>>>>>> 1a5481a (Chapter 11)
    end
  end

  def edit; end

<<<<<<< HEAD
  # PATCH/PUT: /users/:id
=======
>>>>>>> b6ba749 (Chapter 10)
  def update
    if @user.update user_params
      flash[:success] = t("users.update.success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

<<<<<<< HEAD
  # GET: /users
  def index
    @pagy, @users = pagy User.newest_first, items: Settings.page_10
  end

  # DELETE: /users/:id
=======
  def index
    @pagy, @users = pagy User.all, items: Settings.page_10
  end

>>>>>>> b6ba749 (Chapter 10)
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
<<<<<<< HEAD
    return if current_user.admin?

    redirect_to root_path
=======
    redirect_to(root_path) unless current_user.admin?
>>>>>>> b6ba749 (Chapter 10)
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
