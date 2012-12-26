class LengthenIdentifierBody < ActiveRecord::Migration
  def change
    change_column :identifiers, :body, :string, limit: 2048
  end
end
