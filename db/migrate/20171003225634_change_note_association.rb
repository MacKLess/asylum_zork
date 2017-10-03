class ChangeNoteAssociation < ActiveRecord::Migration[5.1]
  def change
    remove_column :notes, :room_id
    add_column :notes, :room_name, :string
  end
end
