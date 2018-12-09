class AddInstantToCrafts < ActiveRecord::Migration[5.2]
  def change
    add_column :crafts, :instant, :integer, default: 0
  end
end
