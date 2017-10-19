class CreateUsersTable < ActiveRecord::Migration[5.1]
  def change
    create_table(:users) do |t|
      t.column(:moves, :integer)
      t.column(:game_text, :text)
      t.timestamps
    end
  end
end
