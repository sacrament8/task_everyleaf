class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 80 }
  validates :content, presence: true, length: { maximum: 300 }
  validates :deadline, presence: true
  validates :status, presence: true
end