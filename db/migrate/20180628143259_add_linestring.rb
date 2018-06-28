class AddLinestring < ActiveRecord::Migration[5.1]
  def change
    remove_column :places, :coordinates
  	remove_column :movements, :coordinates
    add_column :movements, :path, :geography, limit: {:srid=>4326, :type=>"linestring", :geographic=>true}
  end
end
