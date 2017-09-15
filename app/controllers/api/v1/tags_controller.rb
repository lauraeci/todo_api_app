class Api::V1::TagsController < ApplicationController
  before_action :set_tag, only: [:show, :update, :destroy]

  def index
    @tags = Tag.all

    render json: @tags, each_serializer: Api::V1::TagsSerializer, status: :ok
  end

  def update
    data = params['data']
    type = params['type']
    id = params['id']
    puts id

    @tag.update_attributes(tag_params["attributes"])

    if type == 'tasks'
      task = Task.find id
      if task
        puts task
        if task.tagged_with?(@tag)
          task.tags << @tag
        end
        return render json: task, serializer: Api::V1::TasksSerializer, status: :ok
      else
        return render nothing: true, status: :no_content
      end
    end
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      render json: @tag, serializer: Api::V1::TagsSerializer, status: :created
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
end
