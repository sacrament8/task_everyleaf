require 'date'
class AddColumnTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :date, default: Date.today + 7, null: false
  end
end