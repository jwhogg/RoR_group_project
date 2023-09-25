require 'rails_helper'
require_relative '../spec_helper.rb'

RSpec.describe 'User Authentication', type: :feature do

	let!(:user) { FactoryBot.create(:user, password: "Password123!") }
  	let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "Password123!", admin: true) }

  	before :each do
    	nil
  	end

  	specify 'As a guest, I cannot access search page without logging in' do
	  	visit '/'
	  	visit 'search'

	  	expect(page).to have_content("You need to sign in or sign up before continuing.")
	    expect(page).to have_current_path('/users/sign_in')

	    sign_in_user
	    visit '/search'

	    expect(page).to have_current_path('/search')
	end

  	specify 'As a guest, I cannot access WP support without logging in' do
	  	visit '/'
	  	visit 'wp_support'

	  	expect(page).to have_content("You need to sign in or sign up before continuing.")
	    expect(page).to have_current_path('/users/sign_in')

	    sign_in_user
	    visit '/wp_support'

	    expect(page).to have_current_path('/wp_support')
	end

  	specify 'As a guest, I cannot access finances without logging in' do
	  	visit '/'
	  	visit 'finances'

	  	expect(page).to have_content("You need to sign in or sign up before continuing.")
	    expect(page).to have_current_path('/users/sign_in')

	    sign_in_user
	    visit '/finances'

	    expect(page).to have_current_path('/finances')
	end

  	specify 'As a guest, I cannot access FAQ without logging in' do
	  	visit '/'
	  	visit 'faq'

	  	expect(page).to have_content("You need to sign in or sign up before continuing.")
	    expect(page).to have_current_path('/users/sign_in')

	    sign_in_user
	    visit '/faq'

	    expect(page).to have_current_path('/faq')
	end

  	specify 'As a guest, I cannot access admin dashboard without logging in' do
	  	visit '/'
	  	visit 'admin_dashboard'

	  	expect(page).to have_content("You need to sign in or sign up before continuing.")
	    expect(page).to have_current_path('/users/sign_in')

	    sign_in_user
	    visit '/admin_dashboard'

	    expect(page).to have_current_path('/admin_dashboard')
	end

  	specify 'As a guest, I cannot access settings without logging in' do
	  	visit '/'
	  	visit 'users/edit'

	  	expect(page).to have_content("You need to sign in or sign up before continuing.")
	    expect(page).to have_current_path('/users/sign_in')

	    sign_in_user
	    visit '/users/edit'

	    expect(page).to have_current_path('/users/edit')
	end
end

RSpec.describe 'Vunerabilities', type: :feature do

	let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "Password123!", admin: true) }
	let!(:user) { FactoryBot.create(:user, password: "Password123!") }

	before :each do
    	nil
  	end

  	specify "As an admin, I cannot perform an SQL injection attack" do
  		sign_in_admin
  		visit '/'
  		visit 'search'
	    click_on 'New Elective'
	    fill_in 'elective_Title', with: "SQL_INJECTION"
	    fill_in 'elective_Description', with: "sql') OR '1'--"
	    fill_in 'elective_Speciality', with: "sql') OR '1'--"
	    check 'elective_Accomodation'
	    check 'elective_WP_Support'
	    fill_in 'elective_Type', with: "///"
	    click_on 'Save'
  	
	  	visit 'search'
	  	click_on id: "search_electives_button"
	  	expect(page).to have_content("sql') OR '1'--")
	end

	# specify "As an admin, I cannot perform XSS attacks" do
	# 	sign_in_admin
	# 	visit '/'
	# 	visit 'search'
	# 	click_on 'New Elective'
	# 	fill_in 'elective_Title', with: "<h1>Hello</h1>
  #                               <script>
  #                                 (function() {
  #                                   window.location.replace('http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html');
  #                                 })();
  #                               </script>"

	# 	click_on 'Save'
	# 	visit elective_path(Elective.last)
	# 	#cant do this test because we are using rack_test driver???
	# 	expect(current_host).to be_in ['http://127.0.0.1', 'http://localhost:3000']
	# 	within(:css, 'h1') { expect(page).not_to have_content 'Hello' }		
	# end

	specify "As a user, I cannot make myself admin", js: true do
		sign_in_user
		visit '/'
		visit '/users/edit'
    	page.execute_script "document.getElementById('edit_user').innerHTML += \"<input value='t' name='user[manager]'>\""


	end
end




