# READ ME  
## Ruby&Framework version  
- ruby 2.6.1
- "rails", "~> 5.2.2", ">= 5.2.2.1"  
## デプロイの手順  
- heroku login
- すでにアプリをデプロイしているならheroku apps:destroy --app アプリ名で消す
- heroku create
- アプリをgitの管理下に置いてcommitしておく
- origin masterの中身をherokuにデプロイ
  - git push heroku master
- 本番環境でテーブルを作成
  - heroku run rails db:migrate
- デプロイされているか確認
  - heroku open
- 更新差分を本番環境に適応させる
  - commit後にgit push heroku master  
## テーブルスキーマ  
- users table
  - ID
  - name:string
  - email:string
  - password_digest:string  

- tasks table
  - ID
  - user_id:bigint(FK)
  - deadline:date
  - status:string
  - title:string
  - priority:integer
  - content:text  

- labels table
  - ID
  - category:integer  

- pastes table
  - ID
  - task_id:bigint(FK)
  - label_id:bigint(FK)  