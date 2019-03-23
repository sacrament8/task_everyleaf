class RemoveDefaultTasksToPriority < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :priority, nil
  end
end
