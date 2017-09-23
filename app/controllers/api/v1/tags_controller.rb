class Api::V1::TagsController < ApplicationController
  before_action :set_tag, only: [:show, :update, :destroy]

  def index
    puts params[:query]
    if params[:query].present?
      query = params[:query]
      puts Tag.where("title LIKE ? ", "%#{query}%".freeze).all.to_sql
      @tags = Tag.where("title LIKE ? ", "%#{query}%".freeze).all
    else
      @tags = Tag.all
    end

    render json: @tags, each_serializer: Api::V1::TagsSerializer, include: ['task'], status: :ok
  end

  def update
    type = tag_params['type']
    id = tag_params['id']

    @tag.update_attributes(tag_params["attributes"])

    if type == 'tasks'
      task = Task.find id
      if task
        return render json: @tag, serializer: Api::V1::TagsSerializer, include: ['task'], status: :ok
      else
        return render json: {errors: "Can't find task id #{id}"}, status: :unprocessable_entity
      end
    end
  end

  def create
    @tag = Tag.new(tag_params[:attributes])

    if @tag.save
      render json: @tag, serializer: Api::V1::TagsSerializer, include: ['task'], status: :created
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
            :type,
            {
                attributes: [:title]
            }
        )
  end
end
