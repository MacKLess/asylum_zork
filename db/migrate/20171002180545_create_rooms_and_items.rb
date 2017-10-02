class CreateRoomsAndItems < ActiveRecord::Migration[5.1]
  def change
    create_table(:rooms) do |t|
      t.column(:name, :string)
      t.column(:description, :text)
      t.column(:x_coordinate, :integer)
      t.column(:y_coordinate, :integer)
      t.column(:active, :boolean)
      t.column(:solution_item, :string)
      t.column(:success_room, :integer)
      t.column(:north_exit, :boolean)
      t.column(:east_exit, :boolean)
      t.column(:south_exit, :boolean)
      t.column(:west_exit, :boolean)
      t.timestamps
    end

    create_table(:items) do |t|
      t.column(:name, :string)
      t.column(:room_id, :integer)
      t.column(:in_inventory, :boolean)
      t.column(:used, :boolean)
    end
  end
end
