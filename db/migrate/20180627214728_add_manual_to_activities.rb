class AddManualToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :manual, :boolean
  end
end
