class FixColumnName < ActiveRecord::Migration[5.1]
  def change
  	rename_column :movements, :type, :movement_type
  end
end
