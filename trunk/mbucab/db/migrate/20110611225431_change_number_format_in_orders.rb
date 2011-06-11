class ChangeNumberFormatInOrders < ActiveRecord::Migration
  def self.up
    change_column :orders, :number, :string
  end

  def self.down
    change_column :orders, :number, :integer
  end
end
