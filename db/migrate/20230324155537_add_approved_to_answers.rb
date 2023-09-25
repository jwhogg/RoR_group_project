class AddApprovedToAnswers < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:answers, :approved)
      add_column :answers, :approved, :boolean, default: false
    end
  end
end