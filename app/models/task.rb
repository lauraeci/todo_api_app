class Task < ApplicationRecord
  has_many :tasks_tags, class_name: 'TasksTag'
  has_many :tags, :through => :tasks_tags

  def format_tags
    tags.each.map do |tag|
      Api::V1::TagsSerializer.new(tag)
    end
  end


  def tagged_with?(tag)
    return false if tags.index(tag).nil?
    return true
  end

  def add_tag(tag_name)
    tag = Tag.new(title: tag_name)
    tag.save
    tags << tag
  end

end