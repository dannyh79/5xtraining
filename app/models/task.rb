class Task < ApplicationRecord
  validates :title, :start_time, :end_time, :description, presence: true
  validate :end_time_after_start_time

  scope :with_created_at, ->(param) { order(created_at: param) }

  private

  def end_time_after_start_time
    # jumps out if either one is blank
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(
        :end_time, 
        I18n.t(
          "activerecord.errors.models.task.attributes.must_be_after_the_start_time"
        )
      ) 
    end 
  end
end
