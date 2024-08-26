class AddFieldsToSubmissions < ActiveRecord::Migration[7.2]
  def change
    add_column :submissions, :language, :string
    add_column :submissions, :output, :text
    add_column :submissions, :success, :boolean
  end
end
