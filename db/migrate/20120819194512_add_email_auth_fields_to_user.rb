class AddEmailAuthFieldsToUser < ActiveRecord::Migration
  def change
    ## Database authenticatable
    add_column :users, :email,              :string, :null => false, :default => ""
    add_column :users, :encrypted_password, :string, :null => false, :default => ""

    ## Rememberable
    add_column :users, :remember_created_at, :datetime

    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
  end
end
