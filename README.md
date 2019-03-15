#READ ME

##テーブルスキーマ
- users table
  - ID
  - name:string
  - email:string
  - password_digest:string

- tasks table
  - ID
  - user_id:bigint(FK)
  - deadline:datetime
  - status:integer
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