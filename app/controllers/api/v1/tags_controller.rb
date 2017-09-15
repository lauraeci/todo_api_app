class Api::V1::TagsController < ApplicationController
  before_action :set_tag, only: [:show, :update, :destroy]
  before_filter :json_api

  def json_api
    ActiveModelSerializers.config.adapter = :json_api
  end

  def index
    @tags = Tag.all

    tags = @tags.map do |t|
      serializer.new(t).to_json
    end

    render json: tags, status: :ok
  end

  def update
    data = params['data']
    type = params['type']
    id = id['id']

    if type == 'tasks'
      task = Task.find id
      if task
        @tag.update_attributes(tag_params)
        if task.tagged_with?(@tag)
          task.tags << @tag
        end
        return render json: Api::V1::TagsSerializer.new(@tag).attributes[:tags], status: :ok
      end
    end
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      data = serializer.new(@tag)
      render json: data, status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  protected

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:data)
        .permit(
            :id,
            {
                attributes: [:title]
            }
        )
  end

  def serializer
    Api::V1::TagsSerializer
  end
end
