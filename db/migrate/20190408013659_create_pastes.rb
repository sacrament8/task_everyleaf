class CreatePastes < ActiveRecord::Migration[5.2]
  def change
    create_table :pastes do |t|
      t.references :task, index: true, foreign_key: true
      t.references :label, index: true, foreign_key: true

      t.timestamps
    end
  end
end
