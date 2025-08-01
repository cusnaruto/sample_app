class MicropostsController < ApplicationController
  before_action :logged_in?, only: %i(create destroy)

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t("microposts.create.success")
      redirect_to root_url
    else
      @pagy, @feed_items = pagy(current_user.feed, items: Setting.page_10)
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t("microposts.destroy.success")
    else
      flash[:danger] = t("microposts.destroy.failure")
    end
    redirect_to request.referer || root_url
  end

  def feed
    microposts
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost

    flash[:danger] = t("microposts.not_found")
    redirect_to request.refferer || root_url
  end
end
