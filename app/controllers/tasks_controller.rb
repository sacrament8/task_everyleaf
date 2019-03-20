class TasksController < ApplicationController
  before_action :set_task, only: %w(show edit update destroy)
  def index
    if params[:sort_flag]
      @tasks = Task.all.order(deadline: "DESC")
    else
      @tasks = Task.all.order(created_at: "DESC")
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'タスクの作成に成功しました'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'タスクの更新に成功しました'
    else
      flash.now[:danger] = '入力に不備があります'
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'タスクの削除に成功しました'
  end
  
  private


  def task_params
    params.require(:task).permit(:title, :content, :deadline)
  end
  
  def set_task
    @task = Task.find(params[:id])
  end
end