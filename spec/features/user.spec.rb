require "rails_helper"
require "date"
RSpec.feature "ユーザー関連", type: :feature do
  feature "サインイン/サインアウト機能" do
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
      visit task_path(@task.id)
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

  feature "Adminユーザー関連" do
    background do
      #共通のユーザー作成とログイン処理
      @user = create(:user)
      visit new_session_path
      fill_in "sign_in_email", with: "test@test.com"
      fill_in "sign_in_pass", with: "111111"
      find("#sign_in_btn").click
    end

    scenario "admin_new_user_pathからユーザーを作成し成功すると、ユーザー一覧に飛ばされて
    ユーザー「登録ユーザー名」を登録しましたとflashが表示される" do
      visit admin_users_path
      click_on "新規ユーザー作成"
      fill_in "user_name", with: "テストユーザー"
      fill_in "user_email", with: "hogehoge@gmail.com"
      fill_in "user_pass", with: "testpass"
      fill_in "user_pass_confirm", with: "testpass"
      click_on "ユーザー登録"
      expect(page).to have_content "ユーザー「テストユーザー」を登録しました"
      expect(page).to have_content "0"
    end

    scenario "admin_new_user_pathからユーザーを作成し失敗すると、new_admin_user_pathをレンダーし
    入力に不備があります、入力欄を確認してくださいとflashを表示" do
      visit admin_users_path
      click_on "新規ユーザー作成"
      fill_in "user_name", with: "テストユーザー"
      fill_in "user_email", with: ""
      fill_in "user_pass", with: ""
      fill_in "user_pass_confirm", with: ""
      click_on "ユーザー登録"
      expect(page).to have_content "入力に不備があります、入力欄を確認してください"
      expect(page).to have_content "メールアドレスを入力してください"
      expect(page).to have_content "パスワードを入力してください"
    end

    scenario "2ユーザー作成してユーザー一覧をみると登録ユーザー全ての名前とタスク数が表示されている" do
      create(:user, name: 'fugafuga', email: 'test99@test.com')
      @user = create(:user, name: 'hogehoge', email: 'test88@test.com')
      create(:task, user_id: @user.id)
      create(:task, user_id: @user.id)
      visit admin_users_path
      expect(page).to have_content "fugafuga"
      expect(page).to have_content "hogehoge"
      expect(page).to have_content "0"
      expect(page).to have_content "2"

    end

    scenario "ユーザー名testmanを更新してテストユーザーに変更すると一覧に変更が反映され
    ユーザー「テストユーザー」の情報を更新しましたとflashを表示" do
      visit edit_admin_user_path(@user)
      fill_in "user_name", with: "テストユーザー"
      fill_in "user_pass", with: "111111"
      fill_in "user_pass_confirm", with: "111111"
      click_on "ユーザー更新"
      expect(page).to have_content "テストユーザー"
      expect(page).to have_content "0"
      expect(page).not_to have_content "testman"
    end

    scenario "ユーザー名更新に空欄で更新をかけて失敗するとedit_admin_user_pathをレンダーして
    入力に不備があります、入力欄を確認してくださいとflashを表示" do
      visit edit_admin_user_path(@user)
      fill_in "user_name", with: ""
      fill_in "user_pass", with: ""
      fill_in "user_pass_confirm", with: ""
      click_on "ユーザー更新"
      expect(page).to have_content "入力に不備があります、入力欄を確認してください"
    end
  end
end