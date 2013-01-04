class WelcomeController < ApplicationController
  def index
    if signed_in?
      begin
        @discussions = Discussion.of_articles(current_user.articles)
        @number_of_articles_without_discussions = current_user.articles.count - @discussions.count
      rescue Discussion::EngineUnreachableException => e
        flash.now[:alert] = "Discussion matching is temporarily unavailable."
      end
    else
      @suppress_navigation = true
    end
  end
end
