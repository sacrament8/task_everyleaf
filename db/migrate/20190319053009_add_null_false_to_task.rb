class AddNullFalseToTask < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tasks, :title, false
    change_column :tasks, :content, :text, null: false
  end
end
