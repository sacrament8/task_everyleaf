# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require 'rails_helper'
require 'date'
# このRSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  background do
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
  end
  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  scenario "タスク一覧のテスト" do
    visit tasks_path
    expect(page).to have_content 'Factoryで作ったデフォルトのタイトル1'
    expect(page).to have_content 'Factoryで作ったデフォルトのタイトル2'
  end

  scenario "タスク作成のテスト" do
    #form入力処理部分、'title'でうまくフォームを認識しなかったので、_formのtext_fieldにid: 'title'追記の必要あり
    visit new_task_path
    fill_in 'title', with: 'foo'
    fill_in 'content', with: 'bar'
    select '2019', from: 'task_deadline_1i'    #daedlineカラム追加により追記
    select '3', from: 'task_deadline_2i'       #daedlineカラム追加により追記
    select '27', from: 'task_deadline_3i'      #daedlineカラム追加により追記
    click_on '作成'
    expect(page).to have_content 'foo'
    expect(page).to have_content 'bar'
    expect(page).to have_content '2019-03-27'  #daedlineカラム追加により追記
  end

  scenario "タスク詳細のテスト" do
    visit tasks_path
    click_on '詳細', match: :first
    expect(page).to have_content 'Factoryで作ったデフォルトのタイトル2'
    expect(page).to have_content 'Factoryで作ったデフォルトのコンテント2'

  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
    Task.create!(title: '最新のタイトル', content: '最新のコンテント', deadline: '2019-03-23')
    visit tasks_path
    click_on '詳細', match: :first
    expect(page).to have_content '最新のタイトル'
    expect(page).to have_content '最新のコンテント'
    expect(page).to have_content '2019-03-23'
  end

  scenario "終了期限でソートするを押すと2番目に登録した終了期限が一番近いタスク(3/25)が上にくるかのテスト" do
    #ファクトリーで3/30が最初、次に3/25日が終了期限のタスクが作成される
    #ここで3/28が期限のタスクを作ると、作成日降順なので普通は3/28のタスクが一番上になる
    #終了期限でソートを押したら終了期限が迫っているものが一番上にソートされるので一番上が3/25のタスクが来ていればテスト成功
    Task.create(title: 'last_create_task', content: 'last_create_content', deadline: '2019-03-28')
    visit tasks_path
    click_on '終了期限でソート'
    click_on '詳細', match: :first
    save_and_open_page
    expect(page).to have_content 'Factoryで作ったデフォルトのタイトル2'
    expect(page).to have_content 'Factoryで作ったデフォルトのコンテント2'
    expect(page).to have_content '2019-03-25'
  end
  
end