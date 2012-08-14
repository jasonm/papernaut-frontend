class AddMendeleyOauthFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mendeley_uid, :integer
    add_column :users, :mendeley_token, :string
    add_column :users, :mendeley_secret, :string
    add_column :users, :mendeley_username, :string
  end
end
