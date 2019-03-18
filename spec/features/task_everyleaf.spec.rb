# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require 'rails_helper'

# このRSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  scenario "タスク一覧のテスト" do
    Task.create!(title: 'test1', content: 'foo')
    Task.create!(title: 'test2', content: 'bar')
    visit tasks_path
    expect(page).to have_content 'foo'
    expect(page).to have_content 'bar'
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
    Task.create!(title: 'hello', content: 'world')
    visit tasks_path
    click_on '詳細'
    expect(page).to have_content 'hello'
    expect(page).to have_content 'world'
  end
end