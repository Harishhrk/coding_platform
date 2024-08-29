class ModifyUsersT < ActiveRecord::Migration[7.2]
  def change
    # Remove the admin column if it exists
    remove_column :users, :admin if column_exists?(:users, :admin)

    # Add the admin column with a default value of false
    add_column :users, :admin, :boolean, default: false, null: false unless column_exists?(:users, :admin)
  end
end
