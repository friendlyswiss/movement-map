class FixColumnNames < ActiveRecord::Migration[5.1]
  def change
  	rename_column :movements, :activity, :type_name
  	rename_column :activities, :type, :type_name
  end
end
