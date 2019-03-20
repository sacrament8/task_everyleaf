class TasksController < ApplicationController
  before_action :set_task, only: %w(show edit update destroy)
  def index
    if params[:search_flag] == "true"     # 検索フォームからの処理
      binding.pry
      if params[:search_title] && params[:search_status]    # 入力欄どちらもあり
        @tasks = Task.where('status LIKE ?', "%#{params[:search_status]}%").where('title LIKE ?', "%#{params[:search_title]}%")
      elsif params[:search_title].blank? && params[:search_status]     # タイトルのみ空
        @tasks = Task.where('status LIKE ?', "%#{params[:search_status]}%")
      elsif params[:search_title] && params[:search_status].blank?       # ステータスのみ空
        @tasks = Task.where('title LIKE ?', "%#{params[:search_title]}%")
      elsif params[:search_title].blank? && params[:search_status].blank?  # ステータスもタイトルも空
        @tasks = Task.all.order(created_at: "DESC")
      end
    else     # 検索フォームから以外の処理
      if params[:sort_flag]       #ソートリンク(終了期限でソート)からの処理
        @tasks = Task.all.order(deadline: "ASC")
      else                        #ソートリンク(タスク追加が新しい順にソート)からの処理
        @tasks = Task.all.order(created_at: "DESC")
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