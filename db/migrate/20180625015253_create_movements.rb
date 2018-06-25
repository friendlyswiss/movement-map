class CreateMovements < ActiveRecord::Migration[5.1]
  def change
    create_table :movements do |t|
      t.string :type
      t.datetime :start_time
      t.datetime :end_time
      t.string :coordinates
      t.integer :steps
      t.integer :calories

      t.timestamps
    end
  end
end
