class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build if logged_in?
      @pagy, @feed_items = pagy(current_user.feed, items: Settings.page_10)
    end
  end
  def contact; end
end
