class RemoveFulladdressFromOrder < ActiveRecord::Migration
  def self.up
    remove_column :orders, :fulladdress
  end

  def self.down
    add_column :orders, :fulladdress, :string
  end
end
