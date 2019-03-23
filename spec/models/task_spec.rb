require 'rails_helper'

RSpec.describe Task, type: :model do

  describe "validation" do
    before do
      @task = build(:task)
    end
    it "titleが空ならバリデーションが通らない" do
      @task.title = ""
      expect(@task).not_to be_valid
    end

    it "contentが空ならバリデーションが通らない" do
      @task.content = ""
      expect(@task).not_to be_valid
    end

    it "deadlineが空ならバリデーションが通らない" do
      @task.deadline = ""
      expect(@task).not_to be_valid
    end

    it "statusが空ならバリデーションが通らない" do
      @task.status = ""
      expect(@task).not_to be_valid
    end

    it "priorityが空ならバリデーションが通らない" do
      @task.priority= ""
      expect(@task).not_to be_valid
    end

    it "titleとcontentとstatusとdeadlineが記載されていればバリデーションが通る" do
      expect(@task).to be_valid
    end

    it "titleが81文字以上だとバリデーションが通らない" do
      @task.title = 't'*81
      expect(@task).not_to be_valid
    end

    it "titleが80以下だとバリデーションが通る" do
      @task.title = 't'*80
      expect(@task).to be_valid
    end

    it "contentが301文字以上だとバリデージョンが通らない" do
      @task.content = 't'*301
      expect(@task).not_to be_valid
    end

    it "contentが300文字以下だとバリデーションが通る" do
      @task.content = 't'*300
      expect(@task).to be_valid
    end
  end

  describe "scope" do
    before do
      create(:task)
      create(:second_task)
      create(:third_task)
      create(:fourth_task)
    end
    it "status_title_like_whereのテスト" do
      expect(Task.status_title_like_where("着手中", "タイトル4")).to eq Task.where("status LIKE ?", "%着手中%").where("title LIKE ?", "%タイトル4%")
    end

    it "status_like_whereのテスト" do
      expect(Task.status_like_where("完了")).to eq Task.where("status LIKE ?", "%完了%")

    end

    it "title_like_whereのテスト" do
      expect(Task.title_like_where("タイトル2")).to eq Task.where("title LIKE ?", "%タイトル2%")
    end

    it "deadline_ascのテスト" do
      expect(Task.deadline_asc).to eq Task.all.order(deadline: "ASC")
    end

    it "created_at_descのテスト" do
      expect(Task.created_at_desc).to eq Task.all.order(created_at: "DESC")
    end

    it "priority_ascのテスト" do
      expect(Task.priority_asc).to eq Task.all.order(priority: "ASC")
    end

  end
end