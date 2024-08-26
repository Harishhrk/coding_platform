class CreateProblems < ActiveRecord::Migration[7.2]
  def change
    create_table :problems do |t|
      t.string :title
      t.text :description
      t.string :difficulty

      t.timestamps
    end
  end
end
