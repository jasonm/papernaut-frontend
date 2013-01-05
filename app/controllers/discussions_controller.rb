class DiscussionsController < ApplicationController
  def index
    unless signed_in?
      redirect_to root_url
      return
    end

    begin
      @discussions = Discussion.of_articles(current_user.articles)
      @number_of_articles_without_discussions = current_user.articles.count - @discussions.count
    rescue Discussion::EngineUnreachableException => e
      flash.now[:alert] = "Discussion matching is temporarily unavailable."
    end
  end
end
