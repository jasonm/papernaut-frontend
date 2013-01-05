class BibtexImportsController < ApplicationController
  def new
    sign_in(User.create_guest) unless signed_in?

    @bibtex_import = BibtexImport.new
  end

  def create
    bibtex_import = BibtexImport.new(params[:bibtex_import])
    bibtex_import.user = current_user
    bibtex_import.save

    redirect_to root_url, notice: "Imported #{bibtex_import.new_articles.count} papers from #{bibtex_import.filename}."
  end
end
