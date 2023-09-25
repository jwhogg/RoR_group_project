# == Schema Information
#
# Table name: electives
#
#  id           :bigint           not null, primary key
#  Accomodation :boolean
#  Description  :text
#  Location     :string
#  Speciality   :string
#  Title        :string
#  Type         :string
#  WP_Support   :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Elective, type: :model do
  pending "# Currently no methods in the electives model to test #{__FILE__}"
end
