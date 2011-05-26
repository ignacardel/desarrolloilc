class AddRouteIdToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :route_id, :integer
  end

  def self.down
    remove_column :orders, :route_id
  end
end
