require 'rails_helper'
require_relative '../spec_helper.rb'

RSpec.describe 'Interacting with site as an admin', type: :feature do
  # Creates a temporary user with email 'my.email@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "Password123!") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "Password123!", admin: true) }

  before :each do
    nil
  end

  specify 'can login as an admin' do
    sign_in_admin

    expect(page).to have_current_path("/")

    logout_user

    expect(page).to have_current_path("/")
  end
  
  specify 'can visit the electives page' do
    elective_as_admin

    expect(page).to have_current_path('/electives')
    expect(page).to have_content("Listing Electives")
    expect(page).to have_link("New Elective")
  end

  specify 'can access the admin dashboard' do
    visit_dashboard

    expect(page).to have_current_path('/admin_dashboard')
    expect(page).to have_content("Admin Dashboard")
    expect(page).to have_content("Questions")
  end

  specify 'can access settings page' do
    sign_in_admin
    visit '/users/edit'

    expect(page).to have_current_path('/users/edit')
    expect(page).to have_content('Edit User')
    expect(page).to have_content('Cancel my account')
  end

  specify 'can create new elective through elective page' do
    elective_as_admin

    expect(page).to have_link("New Elective")

    # This is elective with ID = 1
    create_new_elective

    expect(page).to have_content("Elective was successfully created.")
    expect(page).to have_content("Test Elective")
    expect(page).to have_current_path("/electives/1")

    visit '/electives'

    expect(page).to have_current_path("/electives")
    within(:css, "table") { expect(page).to have_content 'Test Elective' }
    within(:css, "table") { expect(page).to have_content 'Lorem ipsum delorum' }
  end

  specify 'can expand an elective' do
    elective_as_admin
    # This is elective with ID = 2
    create_new_elective
    visit '/electives'

    expect(page).to have_current_path('/electives')

    click_on 'Show'
    expect(page).to have_content("Accomodations")
    expect(page).to have_link('Edit')
    expect(page).to have_link('View Q&A')
    expect(page).to have_current_path('/electives/2')
  end

  specify 'can edit a newly created elective' do
    elective_as_admin
    # This is elective with ID = 3
    create_new_elective
    click_on 'Edit'

    expect(page).to have_current_path('/electives/3/edit')

    edit_elective
    visit '/electives'

    expect(page).to have_current_path('/electives')
    within(:css, "table") { expect(page).to have_content '1234' }
  end

  specify 'can delete newly created elective' do
    elective_as_admin
    # This is elective with ID = 4
    create_new_elective
    visit '/electives'
    click_on 'Destroy'

    expect(page).to have_content("Elective was successfully destroyed.")
    expect(page).to have_current_path('/electives')
  end

  specify 'can view questions on an elective' do
    elective_as_admin
    # This is elective with ID = 5
    create_new_elective
    visit 'electives/5'
    click_link 'View Q&A'

    expect(page).to have_current_path('/electives/5/questions')
    expect(page).to have_link('Ask a new question')
  end

  specify 'can approve a requested question submission and see on that elective' do
    elective_as_admin
    # This is elective with ID = 6
    create_new_elective
    click_link 'View Q&A'
    click_link 'Ask a new question'
    # This is the question with ID = 1
    submit_question
    approve_question
    sign_in_user
    visit '/electives/6'
    
    expect(page).to have_link('View Q&A')

    click_link 'View Q&A'

    expect(page).to have_content('Test Title')
  end

  specify 'can deny a requested question submission and not see on that elective' do
    elective_as_admin
    # This is elective with ID = 7
    create_new_elective
    click_link 'View Q&A'
    click_link 'Ask a new question'
    # This is the question with ID = 2
    submit_question
    deny_question
    sign_in_user
    visit '/electives/7'

    expect(page).to have_link('View Q&A')

    click_link 'View Q&A'

    expect(page).to_not have_link('Test Title')
  end

  specify 'can approve a requested question and deny and answer submission' do
    elective_as_admin
    # This is elective with ID = 8
    create_new_elective
    click_link 'View Q&A'
    click_link 'Ask a new question'
    # This is the question with ID = 3
    submit_question
    visit_dashboard
    click_link 'Approve'
    visit '/electives/8/questions'
    
    expect(page).to have_content('Test Title')
    choose('accordion-3')

    fill_in 'answer[body]', with: 'Answer Body'
    click_button 'Submit Answer'

    expect(page).to have_content('Answer was successfully created.')

    visit_dashboard
    click_on 'Deny'

    expect(page).to have_content("Answer denied and deleted.")

    visit '/electives/8/questions'
    
    choose('accordion-3')

    fill_in 'answer[body]', with: 'Answer Body'
    click_button 'Submit Answer'
    visit_dashboard
    click_on 'Approve'

    expect(page).to have_content("Answer approved.")
  end
end