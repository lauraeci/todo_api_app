class Api::V1::TaskTagsSerializer < ActiveModel::Serializer
  attributes :data

  def data
    {
        id: object.id,
        type: 'tags',
        attributes: {
            tag: object.tag
        }
    }
  end


end
