require 'rails_helper'

RSpec.describe Task, type: :feature do
  let(:title) { Faker::Lorem.sentence }
  let(:description) { Faker::Lorem.paragraph }
  let(:new_title) { Faker::Lorem.sentence }
  let(:new_description) { Faker::Lorem.paragraph }

  describe 'visit the index of tasks' do    
    it do
      visit tasks_path
      expect(Task.any?).to be false
      expect(page).not_to have_css('table tbody tr')
  
      3.times do
        create(:task)
      end
      
      expect(Task.all.size).to be 3
      
      # test if the data entries are shown in index page
      visit tasks_path
      expect(page).to have_css(
                                'table tbody tr:first-child td:first-child', 
                                text: "#{Task.first.title}"
                              )
      expect(page).to have_css(
                                'table tbody tr:first-child td:nth-child(5)', 
                                text: "#{Task.first.description}"
                              )
      
      expect(page).to have_css(
                                'table tbody tr:nth-child(2) td:first-child', 
                                text: "#{Task.second.title}"
                              )
      expect(page).to have_css(
                                'table tbody tr:nth-child(2) td:nth-child(5)', 
                                text: "#{Task.second.description}"
                              )
      
      expect(page).to have_css(
                                'table tbody tr:nth-child(3) td:first-child', 
                                text: "#{Task.third.title}"
                              )
      expect(page).to have_css(
                                'table tbody tr:nth-child(3) td:nth-child(5)', 
                                text: "#{Task.third.description}"
                              )
    end
  end

  describe 'create a task' do
    it 'with title and description' do
      expect(Task.any?).to be false

      create_task_with(title, description)

      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description
      expect(page).to have_content('Success: a new task is created!')
      expect(page).to have_content(title)
      expect(page).to have_content(description)
    end

    it 'without input' do
      expect(Task.any?).to be false

      create_task_with(nil, nil)

      expect(Task.any?).to be false
      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Description can\'t be blank')
    end
    
    it 'without title' do
      expect(Task.any?).to be false

      create_task_with(nil, description)
      
      expect(Task.any?).to be false
      expect(page).to have_content('Title can\'t be blank')
    end

    it 'without description' do
      expect(Task.any?).to be false

      create_task_with(title, nil)

      expect(Task.any?).to be false
      expect(page).to have_content('Description can\'t be blank')
    end
  end

  describe 'view a task' do
    it do
      expect(Task.any?).to be false

      create_task_with(title, description)

      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description

      visit the_task_path(title)
  
      expect(page).to have_content(title)
      expect(page).to have_content(description)
    end
  end

  describe 'edit a task' do
    it 'with new title and new description' do
      expect(Task.any?).to be false
      
      create_task_with(title, description)

      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description
      
      visit the_edit_task_path(title)

      edit_task_with(new_title, new_description)

      expect(Task.first.title).to eq new_title
      expect(Task.first.description).to eq new_description
      
      expect(page).to have_content('Success: the task is updated!')
      expect(page).to have_content(new_title)
      expect(page).to have_content(new_description)
    end

    it 'without input' do
      expect(Task.any?).to be false

      create_task_with(title, description)

      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description

      visit the_edit_task_path(title)
      edit_task_with()
      
      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Description can\'t be blank')
      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description
    end

    it 'without title' do
      expect(Task.any?).to be false

      create_task_with(title, description)

      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description

      visit the_edit_task_path(title)

      edit_task_with(nil, new_description)
      
      expect(page).to have_content('Title can\'t be blank')
      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description
    end
    
    it 'without description' do
      expect(Task.any?).to be false

      create_task_with(title, description)

      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description

      visit the_edit_task_path(title)

      edit_task_with(new_title)

      expect(page).to have_content('Description can\'t be blank')
      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description
    end
  end

  describe 'delete a task' do
    it do
      expect(Task.any?).to be false

      create_task_with(title, description)

      expect(Task.first.title).to eq title
      expect(Task.first.description).to eq description

      click_on 'Delete'

      expect(page).to have_content('Success: the task is deleted!')
      expect(Task.any?).to be false
    end
  end

  private

  def create_task_with(title, description)
    visit new_task_path
    within('form.form_task') do
      fill_in 'Title', with: title
      fill_in 'Description', with: description
      click_on 'Create Task'
    end
  end

  def edit_task_with(new_title = nil, new_description = nil)
    within('form.form_task') do
      fill_in 'Title', with: new_title
      fill_in 'Description', with: new_description
      click_on 'Update Task'
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