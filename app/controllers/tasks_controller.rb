class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)
  before_action :not_enter_no_Sign_in_user, only: %i(index new show edit)
  
  def index
    search_diverge  #タスク取得分岐用メソッド、詳細はprivateに
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "タスクの作成に成功しました"
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
      redirect_to tasks_path, notice: "タスクの更新に成功しました"
    else
      flash.now[:danger] = "入力に不備があります"
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスクの削除に成功しました"
  end
  
  private

  def not_enter_no_Sign_in_user
    unless current_user
      redirect_to new_session_path, notice: "ログインしてください" 
      return
    end
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority)
  end
  
  def set_task
    @task = Task.find_by(id: params[:id])
  end

  def search_diverge
    title = params[:search_title] if params[:search_title].present?
    status = params[:search_status] if params[:search_status].present?

    if params[:search_flag] == "true"     # 検索フォームからの処理か分岐
      if params[:search_title].present? && params[:search_status].present?    # 入力欄どちらもあり
        @tasks = current_user.tasks.page(params[:page]).status_title_like_where(status, title)
      elsif params[:search_title].empty? && params[:search_status].present?     # タイトルのみ空
        @tasks = current_user.tasks.page(params[:page]).status_like_where(status)
      elsif params[:search_title].present? && params[:search_status].empty?      # ステータスのみ空
        @tasks = current_user.tasks.page(params[:page]).title_like_where(title)
      elsif params[:search_title].empty? && params[:search_status].empty?  # ステータスもタイトルも空
        @tasks = current_user.tasks.page(params[:page]).created_at_desc
      end
    else     # 検索フォームから以外の処理
      if params[:sort_flag] == "deadline"       #ソートリンク(終了期限でソート)からの処理
        @tasks = current_user.tasks.page(params[:page]).deadline_asc
      elsif params[:sort_flag] == "priority"    #ソートリンク(優先順位でソート)からの処理
        @tasks = current_user.tasks.page(params[:page]).priority_asc
      else
        @tasks = current_user.tasks.page(params[:page]).created_at_desc           #ソートリンク(タスク追加が新しい順にソート)からの処理
      end
    end
  end
end