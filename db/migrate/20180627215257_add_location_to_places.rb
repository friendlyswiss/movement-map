class AddLocationToPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :places, :location, :point, :geographic => true
  end
end
