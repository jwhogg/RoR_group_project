class AddAdminToUsers < ActiveRecord::Migration[7.0]
  add_column :users, :admin, :boolean, default: false
  def change
  end
end
