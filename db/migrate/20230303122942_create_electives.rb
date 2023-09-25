class CreateElectives < ActiveRecord::Migration[7.0]
  def change
    create_table :electives do |t|
      t.string :Title
      t.text :Description
      t.string :Speciality
      t.string :Location
      t.boolean :Accomodation
      t.boolean :WP_Support
      t.string :Type

      t.timestamps
    end
  end
end
