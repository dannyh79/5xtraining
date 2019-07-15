require 'rails_helper'

RSpec.describe Task, type: :feature do
  let(:title) { Faker::Lorem.sentence }
  let(:start_time) { DateTime.now }
  let(:end_time) { DateTime.now + 1.day }
  let(:description) { Faker::Lorem.paragraph }

  let(:new_title) { Faker::Lorem.sentence }
  let(:new_start_time) { DateTime.now + 1.day }
  let(:new_end_time) { DateTime.now + 2.day }
  let(:new_description) { Faker::Lorem.paragraph }
  let(:task) { create(:task) }

  describe 'visit the index of tasks' do
    it 'should show all the tasks' do  
      expect{ 3.times { create(:task) } }.to change{ Task.count }.from(0).to(3)
      
      visit tasks_path

      titles = all('#table_tasks tr > td:first-child').map(&:text)
      result = Task.all.map { |task| "#{task.title} (#{I18n.t("tasks.table.priority")} #{task.priority})" }
      expect(titles).to eq result
    end
  end

  describe 'create a task' do
    it 'with title and description' do
      expect{ create_task_with(title, start_time, end_time, description) }.to change{ Task.count }.from(0).to(1)

      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description
      expect(page).to have_content(I18n.t("tasks.create.notice"))
      expect(page).to have_content(title)
      expect(page).to have_content(description)
    end

    it 'without input' do
      expect{ create_task_with(nil, nil, nil, nil) }.not_to change{ Task.count }
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
      expect{ create_task_with(nil, start_time, end_time, description) }.not_to change{ Task.count }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.title")} 
        #{I18n.t("activerecord.errors.models.task.attributes.title.blank")}
      ")
    end
    
    it 'without start_time' do
      expect{ create_task_with(title, nil, end_time, description) }.not_to change{ Task.count }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.start_time")} 
        #{I18n.t("activerecord.errors.models.task.attributes.start_time.blank")}
      ")
    end
    
    it 'without end_time' do
      expect{ create_task_with(title, start_time, nil, description) }.not_to change{ Task.count }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.end_time")} 
        #{I18n.t("activerecord.errors.models.task.attributes.end_time.blank")}
      ")
    end
    
    it 'without description' do
      expect{ create_task_with(title, start_time, end_time, nil) }.not_to change{ Task.count }
      expect(page).to have_content("
        #{I18n.t("activerecord.attributes.task.description")} 
        #{I18n.t("activerecord.errors.models.task.attributes.description.blank")}
      ")
    end
  end

  describe 'view a task' do
    context 'views' do
      it 'should have task\'s title and description' do
        visit the_task_path(task.title)
        expect(page).to have_content(task.title)
        expect(page).to have_content(task.description)
      end
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
    context 'views' do
      it 'should not have the deleted task\'s title and description' do
        create(:task)
        old_task_title = Task.last.title
        old_task_description = Task.last.description

        visit tasks_path
        expect{ click_on I18n.t("tasks.table.delete") }.to change{ Task.count }.by(-1)
  
        expect(page).to have_content(I18n.t("tasks.destroy.notice"))
        expect(page).not_to have_content(old_task_title)
        expect(page).not_to have_content(old_task_description)
      end
    end
  end

  describe 'sorting' do
    let(:asc_result) { Task.order(created_at: :asc).pluck(:title) }
    let(:desc_result) { Task.order(created_at: :desc).pluck(:title) }

    before do
      visit tasks_path
    end

    it 'by "created_at" ASC' do
      # initial load
      text_initial_load = all('tr>td:first-child').map(&:text)
      expect(text_initial_load).to eq(asc_result)
      
      # first click: became desc
      click_on I18n.t("tasks.table.created_at")
      text_after_first_click = all('tr>td:first-child').map(&:text)
      expect(text_after_first_click).to eq(desc_result)
      
      # second click: became asc
      click_on I18n.t("tasks.table.created_at")
      text_after_second_click = all('tr>td:first-child').map(&:text)
      expect(text_after_second_click).to eq(asc_result)
    end

    it 'by "created_at" DESC' do
      # initial load
      text_initial_load = all('tr>td:first-child').map(&:text)
      expect(text_initial_load).to eq(asc_result)
      
      # click: became desc
      click_on I18n.t("tasks.table.created_at")
      text_after_click = all('tr>td:first-child').map(&:text)
      expect(text_after_click).to eq(desc_result)      
    end
  end

  private

  def create_task_with(title, start_time, end_time, description)
    visit new_task_path
    within('form.form_task') do
      fill_in I18n.t("tasks.table.title"), with: title
      fill_in I18n.t("tasks.table.start_time"), with: start_time
      fill_in I18n.t("tasks.table.end_time"), with: end_time
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