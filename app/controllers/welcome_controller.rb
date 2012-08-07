class WelcomeController < ApplicationController
  def index
    if signed_in? && current_user.zotero?
      @articles = current_user.zotero_articles
    end
  end
end
