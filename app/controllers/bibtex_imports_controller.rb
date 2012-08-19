class BibtexImportsController < ApplicationController
  def new
    unless signed_in?
      # TODO: redirect to sign up url, or create an anon user and sign them in
      redirect_to root_url, alert: "Please sign in before importing BibTeX"
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
