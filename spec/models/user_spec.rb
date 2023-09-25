# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  is_wp_student          :boolean
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, :type => :model do

  it 'is database authenticable' do
    user = User.create(
      email: 'test@sheffield.ac.uk', 
      password: 'password123!',
      password_confirmation: 'password123!'
    )
    expect(user.valid_password?('password123!')).to be_truthy
  end

  it 'password is not complex enough' do
    user = User.create(
      email: 'test@sheffield.ac.uk', 
      password: 'password',
      password_confirmation: 'password'
    )
    user.valid?
    expect(user.errors[:password]).to include("complexity requirement not met")
  end
  
  it 'password is complex enough' do
    user = User.create(
      email: 'test@sheffield.ac.uk', 
      password: 'Password123!',
      password_confirmation: 'Password123!'
    )
    user.valid?
    expect(user.errors[:password]).to be_empty
  end
end
