class RemoveTagsTypeFromTasksTags < ActiveRecord::Migration[5.1]
  def change
    remove_column :tasks_tags, :tags_type
  end
end
