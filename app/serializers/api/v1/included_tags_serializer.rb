class Api::V1::IncludedTagsSerializer < ActiveModel::Serializer
  attributes :id, :type

  has_many :tasks

end