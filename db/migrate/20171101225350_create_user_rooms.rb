class CreateUserRooms < ActiveRecord::Migration[5.1]
  def change
    create_table(:user_rooms) do |t|
      t.column(:user_id, :integer)
      t.column(:room_id, :integer)
      t.column(:item_id, :integer)
      t.column(:note_id, :integer)
      t.column(:active, :boolean)
      t.column(:visited, :boolean)
      t.timestamps
    end
  end
end
