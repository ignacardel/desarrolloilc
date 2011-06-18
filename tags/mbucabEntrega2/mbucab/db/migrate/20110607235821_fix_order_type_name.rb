class FixOrderTypeName < ActiveRecord::Migration
  def self.up
    rename_column :orders, :type, :order_type
  end

  def self.down
    rename_column :orders, :order_type, :type
  end
end
