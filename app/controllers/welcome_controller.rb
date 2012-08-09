class WelcomeController < ApplicationController
  def index
    if signed_in? && current_user.zotero?
      @articles_with_discussions = current_user.zotero_articles.select { |article| Discussion.for(article).any? }
      @articles_without_discussions = current_user.zotero_articles.select { |article| Discussion.for(article).none? }
    end
  end
end
