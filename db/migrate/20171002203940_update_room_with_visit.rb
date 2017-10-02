class UpdateRoomWithVisit < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :visited, :boolean
    add_column :rooms, :first_impression, :text
  end
end
