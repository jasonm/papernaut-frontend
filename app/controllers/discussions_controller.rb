class DiscussionsController < ApplicationController
  def index
    unless signed_in?
      redirect_to root_url
      return
    end

    begin
      @discussions = Discussion.of_articles(current_user.articles)
    rescue Discussion::EngineUnreachableException => e
      flash.now[:alert] = "Discussion matching is temporarily unavailable."
    end
  end
end
