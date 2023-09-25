require 'rails_helper'
require_relative '../spec_helper.rb'

RSpec.describe 'Interacting with the site as as guest', type: :feature do
  # Creates a temporary user with email 'test@sheffield.ac.uk' and password as below
  # from the factory bot file
  let!(:user) { FactoryBot.create(:user, password: "Password123!") }
  let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "Password123!", admin: true) }
  
  specify 'can create an account and then logout' do
    visit '/'
    click_on 'Login'
    click_on 'Sign up'
    fill_in  'user_email', with: "new_user@sheffield.ac.uk"
    fill_in  'user_password', with: "Password1!"
    fill_in  'user_password_confirmation', with: "Password1!"
    click_on  'Sign up'

    expect(page).to have_content("Welcome! You have signed up successfully.")
    expect(page).to have_current_path('/')

    logout_user

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Login'
  end

  specify 'can login as a user' do
    sign_in_user

    expect(page).to have_content 'Logout'

    logout_user
    
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Login'
  end

  specify 'cannot visit the electives search page until login' do
    visit '/'
    visit '/search'

    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page).to have_current_path('/users/sign_in')

    sign_in_user
    visit '/search'

    expect(page).to have_current_path('/search')
    expect(page).to have_content("Search for an Elective:")
  end

  specify 'cannot visit any other page except login' do
    visit '/'
    visit '/wp_support'

    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page).to have_current_path('/users/sign_in')

    visit '/'
    visit '/finances'

    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page).to have_current_path('/users/sign_in')

    visit '/'
    visit '/faq'

    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(page).to have_current_path('/users/sign_in')
  end
end