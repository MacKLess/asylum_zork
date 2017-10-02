class RemoveUsedAndSuccessRoom < ActiveRecord::Migration[5.1]
  def change
    remove_column :rooms, :success_room
    remove_column :items, :used
  end
end
