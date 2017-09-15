class Tag < ApplicationRecord

  def format_tasks
    task_ids = TasksTag.where(tag_id: id).pluck("task_id")
    tasks = Task.find task_ids
    tasks.each.map do |task|
      Api::V1::TasksSerializer.new(task)
    end
  end
end
