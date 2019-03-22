class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 80 }
  validates :content, presence: true, length: { maximum: 300 }
  validates :deadline, presence: true
  validates :status, presence: true
  #enum
  enum priority: { 高: 0, 中: 1, 低: 2 }
  #scope定義
  scope :status_title_like_where, -> (params1, params2){where('status LIKE ?', "%#{params1}%").where('title LIKE ?', "%#{params2}%")}
  scope :status_like_where, -> (params){where('status LIKE ?', "%#{params}%")}
  scope :title_like_where, -> (params){where('title LIKE ?', "%#{params}%")}
  scope :deadline_asc, -> {all.order(deadline: "ASC")}
  scope :created_at_desc, -> {all.order(created_at: "DESC")}
end