class Task < ApplicationRecord
  scope :created_at_asc, -> { order(created_at: :asc) }
  scope :created_at_desc, -> { order(created_at: :desc)}

  validates :title, :description, presence: true
end
