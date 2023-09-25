class AddElectiveToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :elective, null: true, foreign_key: true

    # Update existing questions to have a valid elective_id
    # Replace '1' with the ID of an existing elective in your database
    Elective.reset_column_information
    Question.update_all(elective_id: 1)

    # Add the NOT NULL constraint to the elective_id column
    change_column_null :questions, :elective_id, false
  end
end
