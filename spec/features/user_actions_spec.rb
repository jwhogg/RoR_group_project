require 'rails_helper'
require_relative '../spec_helper.rb'

RSpec.describe 'Logging in, logging out and changing account as a user', type: :feature do
  # Creates a temporary user with email 'test@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "Password123!") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "Password123!", admin: true) }

  specify 'can change account information' do
    create_user_account
    logout_user
    visit '/users/sign_in'
    fill_in "user_email", with: "test@sheffield.ac.uk"
    fill_in 'user_password', with: "Password1!"
    click_on 'Log in'
    click_on 'Settings'

    expect(page).to have_current_path('/users/edit')
    expect(page).to have_content('Cancel my account')

    fill_in "user_email", with: "test@sheffield.ac.uk"
    fill_in "user_password", with: "Newpassword1!"
    fill_in "user_password_confirmation", with: "Newpassword1!"
    fill_in 'user_current_password', with: "Password1!"
    click_button 'Update'

    expect(page).to have_current_path('/')
    expect(page).to have_content("Your account has been updated successfully.")
  end
end

RSpec.describe 'Interacting with electives as a user', type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "Password123!") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "Password123!", admin: true) }
  let!(:ability) { Ability.new(user) }

  specify 'can access and expand an elective', js: true do
    # This is the elective with ID = 1 due to admin_spec running first
    # And temporary electives are still in existence
    signin_user_with_elective
    
    expect(page).to have_current_path('/')

    visit '/electives/1'

    expect(page).to have_content("Test Elective")
    expect(page).to have_current_path('/electives/1')
  end

  specify 'cannot create any new electives' do
    sign_in_user
    visit '/electives/new'

    expect(page).to have_content("You are not authorized to access this page.")
    expect(page).to have_current_path("/")
  end

  specify 'cannot edit any existing electives' do
    elective_as_admin
    # This is elective with ID = 2
    create_new_elective

    expect(page).to have_current_path('/electives/1')

    logout_user
    sign_in_user
    visit '/electives/1/edit'

    expect(page).to have_content("You are not authorized to access this page.")
    expect(page).to have_current_path("/")
  end
end

RSpec.describe 'Utilising the Questions and Answers on an elective as a user', type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "Password123!") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "Password123!", admin: true) }
  let!(:ability) { Ability.new(user) }

  specify 'can view questions on an elective' do
    elective_as_admin
    # This is the elective with ID = 3
    create_new_elective

    expect(page).to have_current_path('/electives/2')

    logout_user
    sign_in_user
    visit '/electives/2'

    expect(page).to have_link('View Q&A')

    click_link 'View Q&A'

    expect(page).to have_link('Ask a new question')
    expect(page).to have_current_path('/electives/2/questions')
  end

  specify 'can ask a questions on an elective' do
    elective_as_admin
    # This is the elective with ID = 3
    create_new_elective

    expect(page).to have_current_path("/electives/3")

    logout_user
    sign_in_user
    visit '/electives/3'

    expect(page).to have_link('View Q&A')

    click_link 'View Q&A'

    expect(page).to have_link('Ask a new question')
    expect(page).to have_current_path('/electives/3/questions')

    click_link 'Ask a new question'

    expect(page).to have_current_path('/electives/3/questions/new')

    # This is the question with ID = 1
    submit_question
    approve_question
    sign_in_user
    visit '/electives/3/questions'

    expect(page).to have_content('Test Title')
  end

  specify 'can go to ask a question but decide not to' do
    elective_as_admin
    # This is the elective with ID = 4
    create_new_elective

    expect(page).to have_current_path("/electives/4")

    logout_user
    sign_in_user
    visit '/electives/4'

    expect(page).to have_link('View Q&A')

    click_link 'View Q&A'

    expect(page).to have_link('Ask a new question')
    expect(page).to have_current_path('/electives/4/questions')

    click_link 'Ask a new question'

    expect(page).to have_link('Back to questions')
    
    click_link 'Back to questions'

    expect(page).to have_current_path('/electives/4/questions')
  end

  specify 'can view a pre-existing questions on an elective' do
    elective_as_admin
    # This is the elective with ID = 5
    create_new_elective
    visit '/electives/5'
    click_link 'View Q&A'
    click_link 'Ask a new question'
    # This is the question with ID = 2
    submit_question
    approve_question
    sign_in_user
    visit '/electives/5'

    expect(page).to have_link('View Q&A')

    click_link 'View Q&A'

    expect(page).to have_content('Test Title')
    expect(page).to have_current_path('/electives/5/questions')
  end
  
  specify 'can answer a question on an elective', js: true do
    elective_as_admin
    # This is the elective with ID = 6
    create_new_elective
    visit '/electives/6'
    click_link 'View Q&A'
    click_link 'Ask a new question'
    # This is the question with ID = 3
    submit_question
    approve_question
    sign_in_user
    visit '/electives/6'

    expect(page).to have_link('View Q&A')

    click_link 'View Q&A'

    expect(page).to have_content('Test Title')
    
    # Choose accordion is used to open the questions answer section
    choose('accordion-3')
    fill_in 'answer[body]', with: 'Answer Body'
    click_button 'Submit Answer'
    expect(page).to have_content('Answer was successfully created.')

    go_back

    expect(page).to have_current_path('/electives/6/questions')
  end
end

RSpec.describe 'Interacting with the finances page', type: :feature do
  let!(:user) { FactoryBot.create(:user, password: "Password123!") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "Password123!", admin: true) }
  
  specify 'can visit the finances page' do
    sign_in_user
    visit '/finances'

    expect(page).to have_content('Financial Support')
    expect(page).to have_current_path('/finances')
  end

  specify 'can interact with links on the finances page' do
    sign_in_user
    visit '/finances'

    expect(page).to have_current_path("/finances")
    expect(page).to have_link("Undergraduate Financial Support")
    expect(page).to have_link("Scholarship Information")
    expect(page).to have_link("Additional Financial Support")
  end
end