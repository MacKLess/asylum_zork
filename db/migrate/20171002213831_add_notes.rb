class AddNotes < ActiveRecord::Migration[5.1]
  def change
    create_table(:notes) do |t|
      t.column(:room_id, :integer)
      t.column(:note_text, :text)
      t.timestamps
    end
  end
end
