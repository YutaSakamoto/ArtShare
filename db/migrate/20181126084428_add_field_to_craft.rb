class AddFieldToCraft < ActiveRecord::Migration[5.2]
  def change
    add_column :crafts, :latitude, :float
    add_column :crafts, :longitude, :float
  end
end
