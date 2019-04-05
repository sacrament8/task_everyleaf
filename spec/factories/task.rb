# 「FactoryBotを使用します」という記述
FactoryBot.define do

  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    title { 'Factoryタイトル1' }
    content { 'Factoryコンテント1' }
    deadline { '2019-03-30' }
    status { '未着手' }
    priority { 1 }
    user
  end

  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    title { 'Factoryタイトル2' }
    content { 'Factoryコンテント2' }
    deadline { '2019-03-25' }
    status { '着手中' }
    priority { 1 }
    user
  end

  factory :third_task, class: Task do
    title { 'Factoryタイトル3' }
    content { 'Factoryコンテント3' }
    deadline { '2019-03-26' }
    status { '完了' }
    priority { 2 }
    user
  end

  factory :fourth_task, class: Task do
    title { 'Factoryタイトル4' }
    content { 'Factoryコンテント4' }
    deadline { '2019-03-26' }
    status { '着手中' }
    priority { 0 }
    user
  end
end