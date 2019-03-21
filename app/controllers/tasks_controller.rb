class TasksController < ApplicationController
  before_action :set_task, only: %w(show edit update destroy)
  def index
    title = params[:search_title] if params[:search_title].present?
    status = params[:search_status] if params[:search_status].present?

    if params[:search_flag] == "true"     # 検索フォームからの処理か分岐
      if params[:search_title].present? && params[:search_status].present?    # 入力欄どちらもあり
        @tasks = Task.status_title_like_where(status, title)
      elsif params[:search_title].empty? && params[:search_status].present?     # タイトルのみ空
        @tasks = Task.status_like_where(status)
      elsif params[:search_title].present? && params[:search_status].empty?      # ステータスのみ空
        @tasks = Task.title_like_where(title)
      elsif params[:search_title].empty? && params[:search_status].empty?  # ステータスもタイトルも空
        @tasks = Task.created_at_desc
      end
    else     # 検索フォームから以外の処理
      if params[:sort_flag]       #ソートリンク(終了期限でソート)からの処理
        @tasks = Task.deadline_asc
      else                        #ソートリンク(タスク追加が新しい順にソート)からの処理
        @tasks = Task.created_at_desc
      end
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
    params.require(:task).permit(:title, :content, :deadline, :status)
  end
  
  def set_task
    @task = Task.find(params[:id])
  end
end