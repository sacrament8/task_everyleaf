require "rails_helper"
require "date"
RSpec.feature "サインイン/サインアウト機能", type: :feature do
  scenario 'SignUp画面でユーザ登録すると個人ページにリダイレクトされユーザ情報が表示される' do
    visit new_user_path
    fill_in "user_name", with: "testman"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_pass", with: "hogehoge"
    fill_in "user_pass_confirm", with: "hogehoge"
    click_on "ユーザー登録"
    expect(page).to have_content "ようこそtestmanさん"
  end
  scenario "登録済みユーザがSignInページからログインすると個人ページに飛ばされる" do
    create(:user)
    visit new_session_path
    fill_in "sign_in_email", with: "test@test.com"
    fill_in "sign_in_pass", with: "111111"
    find("#sign_in_btn").click
    expect(page).to have_content "ようこそtestmanさん"
  end
  scenario "ログインユーザがSignOutを押すとログアウトして
  SingInページに飛ばされflash[:notice]が表示される" do
    create(:user)
    visit new_session_path
    fill_in "sign_in_email", with: "test@test.com"
    fill_in "sign_in_pass", with: "111111"
    find("#sign_in_btn").click
    click_on "SignOut"
    expect(page).to have_content "ログアウトしました"
  end

  scenario "ログイン時にユーザー登録ページに行くとログインユーザの個人ページに飛ばされて
  あなたは既に登録ユーザーですとflash[:danger]が表示される" do
    visit new_user_path
    fill_in "user_name", with: "testman"
    fill_in "user_email", with: "test@gmail.com"
    fill_in "user_pass", with: "hogehoge"
    fill_in "user_pass_confirm", with: "hogehoge"
    click_on "ユーザー登録"
    visit new_user_path
    expect(page).to have_content "あなたは既に登録ユーザーです"
  end

  scenario "自分以外のユーザの個人ページのURIを叩くと、自分の個人ページに飛ばされて
  自分以外のユーザーページはご覧いただけませんとflash[:danger]が表示される。" do
    @user = create(:user)
    visit new_session_path
    fill_in "sign_in_email", with: "test@test.com"
    fill_in "sign_in_pass", with: "111111"
    find("#sign_in_btn").click
    click_on "SignOut"
    create(:user, email: "hoge@gmail.com")
    visit new_session_path
    fill_in "sign_in_email", with: "hoge@gmail.com"
    fill_in "sign_in_pass", with: "111111"
    find("#sign_in_btn").click
    visit user_path(@user.id)
    expect(page).to have_content "自分以外のユーザーページはご覧いただけません"
  end

  scenario "非ログイン時にタスク一覧に飛ぶとログイン画面に飛ばされログインしてくださいとflashが表示される" do
    visit tasks_path
    expect(page).to have_content "ログインしてください"
    expect(page).to have_content "SignIn"
  end

  scenario "非ログイン時にタスク作成画面に飛ぶとログイン画面に飛ばされログインしてくださいとflashが表示される" do
    visit new_task_path
    expect(page).to have_content "ログインしてください"
    expect(page).to have_content "SignIn"
  end

  scenario "非ログイン時にタスク詳細のURIを直接叩くとログイン画面に飛ばされログインしてくださいとflashが表示される" do
    @user = create(:user)
    @task = create(:task, user_id: @user.id)
    visit task_path(@user.tasks.first.id)
    expect(page).to have_content "ログインしてください"
    expect(page).to have_content "SignIn"
  end

  scenario "非ログイン時にタスク編集のURIを直接叩くとログイン画面に飛ばされログインしてくださいとflashが表示される" do
    @user = create(:user)
    @task = create(:task, user_id: @user.id)
    visit edit_task_path(@user.tasks.first.id)
    expect(page).to have_content "ログインしてください"
    expect(page).to have_content "SignIn"
  end
end