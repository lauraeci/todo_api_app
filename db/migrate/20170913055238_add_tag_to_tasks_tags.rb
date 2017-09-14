class AddTagToTasksTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks_tags, :tag, :string
  end
end
