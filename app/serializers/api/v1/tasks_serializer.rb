class Api::V1::TasksSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_many :tags, serializer: Api::V1::TagsSerializer

end
