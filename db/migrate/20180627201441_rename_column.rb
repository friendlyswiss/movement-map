class RenameColumn < ActiveRecord::Migration[5.1]
  def change
  	rename_column :movements, :movement_type, :activity
  end
end
