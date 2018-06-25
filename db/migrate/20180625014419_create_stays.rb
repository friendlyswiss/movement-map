class CreateStays < ActiveRecord::Migration[5.1]
  def change
    create_table :stays do |t|
      t.integer :place_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
