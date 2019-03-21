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
      let!(:task_a) { create(:task) }
      let!(:task_b) { create(:second_task) }
      let!(:task_c) { create(:third_task) }
      let!(:task_d) { create(:fourth_task) }
    end
    it "status_title_like_whereのテスト" do
      binding.pry
      subject { Task.status_like_where("着手中", "タイトル4") }
      it { is_expected.to eq task_d }
    end

    # it "status_like_whereのテスト" do
    # end

    # it "title_like_whereのテスト" do
    # end

    # it "deadline_ascのテスト" do
    # end

    # it "created_at_descのテスト" do
    # end

  end
end


  