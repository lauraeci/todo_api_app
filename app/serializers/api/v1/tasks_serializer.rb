class Api::V1::TasksSerializer < ActiveModel::Serializer

  attributes :data

  def data
    {
        id: object.id,
        type: 'tasks',
        attributes: {
            title: object.title
        },
        relationships: {
            tags: object.format_tags
        }
    }
  end
end