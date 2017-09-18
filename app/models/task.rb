class Task < ApplicationRecord
  has_many :tasks_tags, class_name: 'TasksTag'
  has_many :tags, :through => :tasks_tags
end