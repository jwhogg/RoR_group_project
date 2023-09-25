class AddApprovedToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :approved, :boolean
  end
end
