class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  before_validation { email.downcase! }
  validates :email, presence: true, uniqueness: true, length: { maximum: 150 },
          format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :name, presence: true, length: { in: 5..30 }
  validates :password, presence: true, length: { in: 5..10 }
  has_secure_password

end