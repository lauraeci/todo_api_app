class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def show
    data = serializer.new(@task)
    render json: data
  end

  def index
    all_tasks = Task.all

    tasks = all_tasks.map do |t|
      serializer.new(t).to_json
    end

    render json: tasks, status: :ok
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      data = serializer.new(@task).to_json
      render json: data, status: :created
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
      data = serializer.new(@task).to_json
      render json: data
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
            :id,
            # has_many: :tags (Nested Attributes)
            {:attributes => [:title, :tags => []]}
        )
  end

  def serializer
    Api::V1::TasksSerializer
  end

end

