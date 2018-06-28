class ChangeGeoColumn < ActiveRecord::Migration[5.1]
  def change
  	remove_column :places, :location # formerly of type :point
    add_column :places, :location, :geography, limit: {:srid=>4326, :type=>"point", :geographic=>true}
  end
end
