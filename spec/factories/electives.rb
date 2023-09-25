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
FactoryBot.define do
  factory :elective do
    Title { "Research Elective" }
    Description { "Lorem ipsum delorum" }
    Speciality { "Research" }
    Location { "United Kingdom" }
    Accomodation { true }
    WP_Support { true }
    Type { "MyString" }
  end
end
