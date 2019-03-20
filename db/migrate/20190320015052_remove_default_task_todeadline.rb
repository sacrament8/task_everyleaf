class RemoveDefaultTaskTodeadline < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :deadline, nil
  end
end
