class WelcomeController < ApplicationController
  def index
    if signed_in?
      @discussions = Discussion.of_articles(current_user.articles)
      @number_of_articles_without_discussions = current_user.articles.count - @discussions.count
    end
  end
end
