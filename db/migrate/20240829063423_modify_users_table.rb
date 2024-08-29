class ModifyUsersTable < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :admin, :boolean unless column_exists?(:users, :admin)

  end
end
