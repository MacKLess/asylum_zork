class CreateInventoryItyItems < ActiveRecord::Migration[5.1]
  def change
    create_table(:inventory_items) do |t|
      t.column(:user_id, :integer)
      t.column(:item_id, :integer)
      t.timestamps
    end
  end
end
