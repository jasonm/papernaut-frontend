class CreateImports < ActiveRecord::Migration
  def up
    create_table(:imports) do |t|
      t.integer :user_id
      t.string :state
    end
  end

  def down
    drop_table(:imports)
  end
end
