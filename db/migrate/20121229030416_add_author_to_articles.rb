class AddAuthorToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :author, :string, :limit => 1024
  end
end
