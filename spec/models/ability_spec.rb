require 'rails_helper'
require_relative '../spec_helper.rb'
require "cancan/matchers"

RSpec.describe Ability, type: :model do
    let!(:user) { FactoryBot.create(:user, password: "Password123!") }
    let!(:admin) { FactoryBot.create(:user, email: "admin@sheffield.ac.uk" ,password: "Password123!", admin: true) }
    
    # Tests the abilites of each role user and admin
    describe '.initialize' do
        subject(:ability_user){ Ability.new(user) }
        subject(:ability_admin){ Ability.new(admin) }
        it 'can distinguish abilities between roles user and admin' do
            expect(ability_user).to be_able_to(:read, Elective.new)
            expect(ability_user).to_not be_able_to(:manage, Elective.new)
            expect(ability_admin).to be_able_to(:manage, Elective.new)
            expect(ability_admin).to be_able_to(:read, Elective.new)
        end
    end
end