class RenameSpotsTypeColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :spots, :type, :spot_type
  end
end
