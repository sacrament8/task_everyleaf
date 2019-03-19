# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require 'rails_helper'

# このRSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  background do
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
  end
  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  scenario "タスク一覧のテスト" do
    visit tasks_path
    expect(page).to have_content 'Factoryで作ったデフォルトのタイトル１'
    expect(page).to have_content 'Factoryで作ったデフォルトのタイトル２'
  end

  scenario "タスク作成のテスト" do
    visit new_task_path
    #form入力処理部分、'title'でうまくフォームを認識しなかったので、_formのtext_fieldにid: 'title'追記の必要あり
    fill_in 'title', with: 'hello'
    fill_in 'content', with: 'world'
    click_on '作成'
    expect(page).to have_content 'world'
    expect(page).to have_content 'hello'
  end

  scenario "タスク詳細のテスト" do
    visit tasks_path
    click_on '詳細', match: :first
    expect(page).to have_content 'Factoryで作ったデフォルトのタイトル２'
    expect(page).to have_content 'Factoryで作ったデフォルトのコンテント２'
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
    Task.create!(title: '最新のタイトル', content: '最新のコンテント')
    visit tasks_path
    save_and_open_page
    click_on '詳細', match: :first
    expect(page).to have_content '最新のタイトル'
    expect(page).to have_content '最新のコンテント'
  end
  
end