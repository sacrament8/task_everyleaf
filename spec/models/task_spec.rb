require 'rails_helper'

RSpec.describe Task, type: :model do

  it "titleが空ならバリデーションが通らない" do
    task = Task.new(title: '', content: '失敗テスト')
    expect(task).not_to be_valid
  end

  it "contentが空ならバリデーションが通らない" do
    task = Task.new(title:'失敗テスト', content: '')
    expect(task).not_to be_valid
  end

  it "titleとcontentに内容が記載されていればバリデーションが通る" do
    task = Task.new(title: '成功テスト', content: '成功テスト')
    expect(task).to be_valid
  end

  it "titleが81文字以上だとバリデーションが通らない" do
    task = Task.new(title: 't'*81, content: '失敗テスト')
    expect(task).not_to be_valid
  end

  it "titleが80以下だとバリデーションが通る" do
    task = Task.new(title: 't'*80, content: '失敗テスト')
    expect(task).to be_valid
  end

  it "contentが301文字以上だとバリデージョンが通らない" do
    task = Task.new(title: '失敗テスト', content: 't'*301)
    expect(task).not_to be_valid
  end

  it "contentが300文字以下だとバリデーションが通る" do
    task = Task.new(title: '失敗テスト', content: 't'*300)
    expect(task).to be_valid
  end
end