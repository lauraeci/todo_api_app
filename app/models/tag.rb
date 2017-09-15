class Tag < ApplicationRecord
  has_many :tasks_tags, class_name: 'TasksTag'
  has_many :tasks, :through => :tasks_tags

end
