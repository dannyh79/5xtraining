class Task < ApplicationRecord
  scope :with_created_at, -> (param) { order(created_at: param) }

  validates :title, :description, presence: true
end
