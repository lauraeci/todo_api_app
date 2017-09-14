class AddTasktagsTypeToTasksTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks_tags, :tags_type, :string
  end
end
