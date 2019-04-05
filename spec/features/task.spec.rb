# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require "rails_helper"
require "date"
# このRSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  background do
    @user = create(:user)
    visit new_session_path
    fill_in "sign_in_email", with: "test@test.com"
    fill_in "sign_in_pass", with: "111111"
    find("#sign_in_btn").click
    create(:task, user_id: @user.id)
    create(:second_task, user_id: @user.id)
    create(:third_task, user_id: @user.id)
    create(:fourth_task, user_id: @user.id)
  end
  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  scenario "タスク一覧のテスト" do
    visit tasks_path
    expect(page).to have_content "Factoryタイトル1"
    expect(page).to have_content "Factoryタイトル2"
  end

  scenario "タスク作成のテスト" do
    #form入力処理部分、"title"でうまくフォームを認識しなかったので、_formのtext_fieldにid: "title"追記の必要あり
    visit new_task_path
    fill_in "title", with: "foo"
    fill_in "content", with: "bar"
    select "2019", from: "task_deadline_1i"
    select "3", from: "task_deadline_2i"
    select "27", from: "task_deadline_3i"
    click_on "作成"
    expect(page).to have_content "foo"
    expect(page).to have_content "bar"
    expect(page).to have_content "2019-03-27"
  end

  scenario "タスク詳細のテスト" do
    visit tasks_path
    click_on "詳細", match: :first
    expect(page).to have_content "Factoryタイトル4"
    expect(page).to have_content "Factoryコンテント4"
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do
    Task.create(title: "最新のタイトル", content: "最新のコンテント", deadline: "2019-03-23", priority: 0, user_id: @user.id)
    visit tasks_path
    click_on "詳細", match: :first
    expect(page).to have_content "最新のタイトル"
    expect(page).to have_content "最新のコンテント"
  end

  scenario "終了期限でソートするを押すと2番目に登録した終了期限が一番近いタスク(3/25)が上にくるかのテスト" do
    #ファクトリーで3/30が最初、次に3/25日が終了期限のタスクが作成される
    #ここで3/28が期限のタスクを作ると、作成日降順なので普通は3/28のタスクが一番上になる
    #終了期限でソートを押したら終了期限が迫っているものが一番上にソートされるので一番上が3/25のタスクが来ていればテスト成功
    Task.create(title: "last_create_task", content: "last_create_content", deadline: "2019-03-28")
    visit tasks_path
    click_on "終了期限でソート"
    click_on "詳細", match: :first
    expect(page).to have_content "Factoryタイトル2"
    expect(page).to have_content "Factoryコンテント2"
    expect(page).to have_content "2019-03-25"
  end

  scenario "優先順位で高い順にソートを押すと最後に登録した唯一の優先度高のタスク4が一番上にくる" do
    visit tasks_path
    click_on "優先順位で高い順にソート"
    click_on "詳細", match: :first
    expect(page).to have_content "Factoryタイトル4"
    expect(page).to have_content "Factoryコンテント4"
    expect(page).to have_content "高"
  end
  
end

RSpec.feature "タスク検索機能", type: :feature do
  background do
    @user = create(:user)
    visit new_session_path
    fill_in "sign_in_email", with: "test@test.com"
    fill_in "sign_in_pass", with: "111111"
    find("#sign_in_btn").click
    create(:task, user_id: @user.id)
    create(:second_task, user_id: @user.id)
    create(:third_task, user_id: @user.id)
    create(:fourth_task, user_id: @user.id)
  end

  scenario "タイトルのみでの絞り込み検索テスト" do
    #ステータスフォームは空欄、タイトルフォームはタイトル3で検索するとレコード3のみが表示される
    visit tasks_path
    fill_in "task_title", with: "タイトル3"
    click_on "検索"
    expect(page).to have_content "Factoryタイトル3"
    expect(page).to have_content "Factoryコンテント3"
    expect(page).to have_content "2019-03-26"
    expect(page).to have_content "完了"
    expect(page).not_to have_content "Factoryタイトル1"
    expect(page).not_to have_content "Factoryタイトル2"
    expect(page).not_to have_content "Factoryタイトル4"
  end

  scenario "ステータスのみでの絞り込み検索テスト" do
    #ステータスフォーム未着手、タイトルフォーム空欄で検索するとレコード1のみが表示される
    visit tasks_path
    select "未着手", from: "search_status"
    click_on "検索"
    expect(page).to have_content "Factoryタイトル1"
    expect(page).not_to have_content "Factoryタイトル2"
    expect(page).not_to have_content "Factoryタイトル3"
    expect(page).not_to have_content "Factoryタイトル4"
  end

  scenario "ステータス、フォームでのアンド検索テスト" do
    #ステータスフォーム着手中、タイトルフォームでタイトル2で絞り込むとレコード2のみ表示される
    visit tasks_path
    select "着手中", from: "search_status"
    fill_in "task_title", with: "タイトル2"
    click_on "検索"
    expect(page).to have_content "Factoryタイトル2"
    expect(page).not_to have_content "Factoryタイトル1"
    expect(page).not_to have_content "Factoryタイトル3"
    expect(page).not_to have_content "Factoryタイトル4"
  end

  scenario "条件なしで検索すると作成日descで全件表示されるテスト" do
    #ステータスフォーム空欄、タイトルフォーム空欄で絞り込むと全件表示され、一番上にレコード4がくる
    visit tasks_path
    click_on "検索"
    expect(page).to have_content "Factoryタイトル1"
    expect(page).to have_content "Factoryタイトル2"
    expect(page).to have_content "Factoryタイトル3"
    expect(page).to have_content "Factoryタイトル4"
    click_on "詳細", match: :first
    expect(page).to have_content "Factoryタイトル4"
    expect(page).to have_content "着手中"
    expect(page).not_to have_content "Factoryコンテント3"
  end

  scenario "存在しないタイトルのみで検索すると何も表示されないテスト" do
    #ステータスフォーム空欄、タイトルフォームでタイトル5で絞り込むと1つもタスクは表示されないつまりタスク1,2,3,4は表示されない
    visit tasks_path
    fill_in "task_title", with: "タイトル5"
    click_on "検索"
    expect(page).not_to have_content "Factoryタイトル1"
    expect(page).not_to have_content "Factoryタイトル2"
    expect(page).not_to have_content "Factoryタイトル3"
    expect(page).not_to have_content "Factoryタイトル4"
  end

end