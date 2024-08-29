class CreateInitialSchema < ActiveRecord::Migration[7.2]
  def change
    # Enable the necessary extensions
    enable_extension "plpgsql" unless extension_enabled?("plpgsql")

    # Create the problems table if it doesn't exist
    unless table_exists?(:problems)
      create_table :problems do |t|
        t.string :title
        t.text :description
        t.string :difficulty
        t.timestamps
      end
    end

    # Create the users table if it doesn't exist
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :username
        t.string :email
        t.string :password_digest
        t.string :token
        t.timestamps
      end
    end

    # Create the submissions table if it doesn't exist
    unless table_exists?(:submissions)
      create_table :submissions do |t|
        t.references :user, null: false, foreign_key: true
        t.references :problem, null: false, foreign_key: true
        t.text :code
        t.string :status
        t.text :result
        t.string :language
        t.text :output
        t.boolean :success
        t.timestamps
      end
    end

    # Create the test_cases table if it doesn't exist
    unless table_exists?(:test_cases)
      create_table :test_cases do |t|
        t.references :problem, null: false, foreign_key: true
        t.text :input
        t.text :expected_output
        t.timestamps
      end
    end

    # Add columns if they don't exist in the relevant tables
    add_column :submissions, :output, :text unless column_exists?(:submissions, :output)
    add_column :submissions, :success, :boolean unless column_exists?(:submissions, :success)
    add_column :submissions, :language, :string unless column_exists?(:submissions, :language)

    # Add indexes if they don't exist
    add_index :submissions, :user_id unless index_exists?(:submissions, :user_id)
    add_index :submissions, :problem_id unless index_exists?(:submissions, :problem_id)
    add_index :test_cases, :problem_id unless index_exists?(:test_cases, :problem_id)
  end
end
