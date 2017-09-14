class Api::V1::TagsSerializer < ActiveModel::Serializer
  attributes :id, :type, :title, :included

  def type
    'tags'
  end

end