class Api::V1::TagsSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_many :tasks, serializer: Api::V1::TasksSerializer

end