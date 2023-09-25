# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  approved    :boolean          default(FALSE)
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
class Answer < ApplicationRecord
  belongs_to :question  
  after_initialize :set_default_values

  private

  def set_default_values
    self.approved ||= false
  end

end
