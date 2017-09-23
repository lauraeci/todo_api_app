class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [:show, :update]

  def show
    render json: @task, serializer: Api::V1::TasksSerializer, status: :ok
  end

  def index
    tasks = Task.all

    render json: tasks, each_serializer: Api::V1::TasksSerializer, include: ['tags'], status: :ok
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      render json: @task, serializer: Api::V1::TasksSerializer, include: ['tags'], status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    attrs = task_params
    if attrs[:attributes][:tags]
      tags = attrs[:attributes][:tags]
      tags.each do |t|
        tag = Tag.find_or_create_by(title: t)
        @task.tasks_tags.create(tag: tag)
      end
    end

    if @task.update_attributes(attrs[:attributes].except(:tags))
      render json: @task, serializer: Api::V1::TasksSerializer, include: ['tags']
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    task = Task.where(id: params[:id]).first
    if task
      task.destroy
      render nothing: true, status: :accepted
    else
      render nothing: true, status: :no_content
    end
  end

  protected

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:data)
        .permit(
            # has_many: :tags (Nested Attributes)
            {:attributes => [:title, :tags => []]}
        )
  end

  def serializer
    Api::V1::TasksSerializer
  end

end

