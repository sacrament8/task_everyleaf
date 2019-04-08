class Label < ApplicationRecord
  validates :name, uniqueness: true
  has_many :tasks, through: :pastes
  has_many :pastes, dependent: :destroy
end
