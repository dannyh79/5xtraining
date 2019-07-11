require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "data input" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it 'should always be after end time' do
      task_with_valid_input = Task.new(
                                title: Faker::Lorem.sentence,
                                start_time: Time.now - 1.day, 
                                end_time: Time.now,
                                description: Faker::Lorem.paragraph
                              )
      task_with_invalid_input = Task.new(
                                  title: Faker::Lorem.sentence,
                                  start_time: Time.now, 
                                  end_time: Time.now - 1.day,
                                  description: Faker::Lorem.paragraph
                                )

      expect{ task_with_valid_input.save }.to change{ Task.count }.by(1)
      expect(task_with_valid_input.errors.any?).to be false
      expect{ task_with_invalid_input.save }.to change{ task_with_invalid_input.errors.full_messages }.from([]).to(["#{I18n.t("activerecord.attributes.task.end_time")} #{I18n.t("activerecord.errors.models.task.attributes.must_be_after_the_start_time")}"])
    end
  end
end
