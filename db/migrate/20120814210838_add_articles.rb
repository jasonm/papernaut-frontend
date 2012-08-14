class AddArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.integer :user_id
      t.string :title, :limit => 1024
      t.string :url, :limit => 1024
      t.string :source
      t.timestamps
    end

    add_index :articles, :user_id

    create_table :identifiers do |t|
      t.integer :article_id
      t.string :body
    end

    add_index :identifiers, :article_id
  end

  def down
    remove_index :identifiers, :column => :article_id
    drop_table :identifiers

    remove_index :articles, :column => :user_id
    drop_table :articles
  end
end
