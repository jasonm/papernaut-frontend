class ImportsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def new
    unless signed_in?
      redirect_to root_url
      return
    end

    if ! params[:process]
      render 'preview'
      return
    end

    articles_before = current_user.articles.count

    current_user.import_from_libraries

    articles_after = current_user.articles.count
    new_articles = articles_after - articles_before
    message = "#{pluralize(new_articles, "new article")} imported from your libraries."

    redirect_to root_url, notice: message
  end
end
