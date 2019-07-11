require 'rails_helper'

RSpec.describe Task, type: :feature do
  let(:title) { Faker::Lorem.sentence }
  let(:description) { Faker::Lorem.paragraph }
  let(:new_title) { Faker::Lorem.sentence }
  let(:new_description) { Faker::Lorem.paragraph }
  let(:task) { create(:task) }

  describe 'visit the index of tasks' do    
    it do  
      3.times do
        create(:task)
      end
      
      expect(Task.count).to be 3
      
      # test if the data entries are shown in index page
      visit tasks_path
      expect(page).to have_css(
                                'table tbody tr:first-child td:first-child', 
                                text: Task.first.title
                              )
      expect(page).to have_css(
                                'table tbody tr:first-child td:nth-child(5)', 
                                text: Task.first.description
                              )
      
      expect(page).to have_css(
                                'table tbody tr:nth-child(2) td:first-child', 
                                text: Task.second.title
                              )
      expect(page).to have_css(
                                'table tbody tr:nth-child(2) td:nth-child(5)', 
                                text: Task.second.description
                              )
      
      expect(page).to have_css(
                                'table tbody tr:nth-child(3) td:first-child', 
                                text: Task.third.title
                              )
      expect(page).to have_css(
                                'table tbody tr:nth-child(3) td:nth-child(5)', 
                                text: Task.third.description
                              )
    end
  end

  describe 'create a task' do
    it 'with title and description' do
      create_task_with(title, description)
      expect(page).to have_content(I18n.t("tasks.create.notice"))
      expect{ create_task_with(title, description) }.to change{ Task.count }.from(0).to(1)

      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description
      expect(page).to have_content((I18n.t("tasks.create.notice"))
      expect(page).to have_content(title)
      expect(page).to have_content(description)
    end

    it 'without input' do
      expect{ create_task_with(nil, nil) }.not_to change{ Task.count }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.title")} 
        #{I18n.t("activerecord.errors.models.task.attributes.title.blank")}
      ")
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.description")} 
        #{I18n.t("activerecord.errors.models.task.attributes.description.blank")}
      ")
    end
    
    it 'without title' do
      expect{ create_task_with(nil, description) }.not_to change{ Task.count }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.title")} 
        #{I18n.t("activerecord.errors.models.task.attributes.title.blank")}
      ")
    end
    
    it 'without description' do
      expect{ create_task_with(title, nil) }.not_to change{ Task.count }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.description")} 
        #{I18n.t("activerecord.errors.models.task.attributes.description.blank")}
      ")
    end
  end

  describe 'view a task' do
    it do
      visit the_task_path(task.title)
  
      expect(page).to have_content(task.title)
      expect(page).to have_content(task.description)
    end
  end

  describe 'edit a task' do
    before(:each) do
      create(:task)
      visit the_edit_task_path(Task.last.title)
    end
    it 'with new title and new description' do
      expect{ edit_task_with(new_title, new_description) }.not_to change { Task.count }

      expect(Task.first.title).to eq new_title
      expect(Task.first.description).to eq new_description
      
      expect(page).to have_content(I18n.t("tasks.update.notice"))
      expect(page).to have_content(new_title)
      expect(page).to have_content(new_description)
    end

    it 'without input' do
      expect { edit_task_with(nil, nil) }.not_to change { Task.first }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.title")} 
        #{I18n.t("activerecord.errors.models.task.attributes.title.blank")}
      ")
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.description")} 
        #{I18n.t("activerecord.errors.models.task.attributes.description.blank")}
      ")
    end
    
    it 'without title' do
      expect { edit_task_with(nil, new_description) }.not_to change { Task.first }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.title")} 
        #{I18n.t("activerecord.errors.models.task.attributes.title.blank")}
      ")
    end
    
    it 'without description' do
      expect { edit_task_with(new_title, nil) }.not_to change { Task.first }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.description")} 
        #{I18n.t("activerecord.errors.models.task.attributes.description.blank")}
      ")
    end
  end

  describe 'delete a task' do
    it do
      create_task_with(title, description)
      expect{ click_on I18n.t("tasks.table.delete") }.to change{ Task.count }.by(-1)

      expect(page).to have_content(I18n.t("tasks.destroy.notice"))
      # check if there's still remnant info, from the deleted, in views
      expect(page).not_to have_content(title)
      expect(page).not_to have_content(description)
    end
  end

  private

  def create_task_with(title, description)
    visit new_task_path
    within('form.form_task') do
      fill_in I18n.t("tasks.table.title"), with: title
      fill_in I18n.t("tasks.table.description"), with: description
      click_on I18n.t("helpers.submit.task.create", model: I18n.t("activerecord.models.task"))
    end
  end

  def edit_task_with(new_title, new_description)
    within('form.form_task') do
      fill_in I18n.t("tasks.table.title"), with: new_title
      fill_in I18n.t("tasks.table.description"), with: new_description
      click_on I18n.t("helpers.submit.task.update", model: I18n.t("activerecord.models.task"))
    end
  end

  def the_task_path(title)
    task_path(find_task_by_title(title))
  end

  def the_edit_task_path(title)
    edit_task_path(find_task_by_title(title))
  end

  def find_task_by_title(title)
    Task.find_by(title: title)
  end
end