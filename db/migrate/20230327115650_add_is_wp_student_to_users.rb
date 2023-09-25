class AddIsWpStudentToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_wp_student, :boolean
  end
end
