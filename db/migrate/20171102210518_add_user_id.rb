class AddUserId < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :user_id, :integer
    add_index :rooms, :user_id
    add_column :items, :user_id, :integer
    add_index :items, :user_id
  end
end
