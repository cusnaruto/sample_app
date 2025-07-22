class MicropostsController < ApplicationController
  def index
    @microposts = Micropost.most_recent
  end
end
