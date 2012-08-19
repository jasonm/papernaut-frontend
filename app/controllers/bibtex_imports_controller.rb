class BibtexImportsController < ApplicationController
  def new
    unless signed_in?
      # TODO: create an anon user and sign them in
      redirect_to new_user_registration_url, alert: "Please sign up so we can upload your BibTeX library:"
      return
    end

    @bibtex_import = BibtexImport.new
  end

  def create
    bibtex_import = BibtexImport.new(params[:bibtex_import])
    bibtex_import.user = current_user
    bibtex_import.save

    redirect_to root_url, notice: "Imported #{bibtex_import.new_articles.count} articles from #{bibtex_import.filename}."
  end
end
