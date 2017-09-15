class Api::V1::TasksSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_many :tags

end
