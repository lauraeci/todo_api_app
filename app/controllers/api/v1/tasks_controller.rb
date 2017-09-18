class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def show
    render json: @task, serializer: Api::V1::TasksSerializer, status: :ok
  end

  def index
    tasks = Task.all

    render json: tasks, each_serializer: Api::V1::TasksSerializer, status: :ok
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      render json: @task, serializer: Api::V1::TasksSerializer, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    attrs = task_params
    if attrs[:attributes][:tags]
      tags = attrs[:attributes][:tags]
      tags.each do |t|
        @task.add_tag(t)
      end
    end

    @task.title = attrs[:attributes][:title]
    if @task.save
      render json: @task, serializer: Api::V1::TasksSerializer
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
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

