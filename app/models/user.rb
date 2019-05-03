require 'date'
class User < ApplicationRecord
  before_destroy :not_last_admin_destroy
  has_many :tasks, dependent: :destroy
  before_validation { email.downcase! }
  validates :email, presence: true, uniqueness: true, length: { maximum: 150 },
          format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :name, presence: true, length: { in: 5..30 }
  validates :password, presence: true, length: { in: 5..10 }
  has_secure_password

  # ステータスが完了でない期限切れタスクを全取得
  def expired
    tasks.where("deadline < ?", Date.today).where.not(status: '完了')
  end
  # ステータスが完了でないあと1日で期限がくる(過ぎてはいない)タスクを全取得
  def one_day_left
    tasks.where("deadline -1 <= ? and deadline >= ?", Date.today, Date.today)
  end
  private

  def not_last_admin_destroy
    raise NotLastAdminDestroy if User.where(admin: true).size <= 1
  end
end