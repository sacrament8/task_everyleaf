module TasksHelper
  def change_submit_name
    if action_name == "new"
      "作成"
    elsif action_name == "edit"
      "編集"
    end
  end
end