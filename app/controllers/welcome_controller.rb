class WelcomeController < ApplicationController
  def index
    if signed_in? && current_user.zotero?
      @discussions = Discussion.of_articles(current_user.zotero_articles)
      @number_of_articles_without_discussions = current_user.zotero_articles.count { |article| Discussion.for(article).none? }
    end
  end
end
