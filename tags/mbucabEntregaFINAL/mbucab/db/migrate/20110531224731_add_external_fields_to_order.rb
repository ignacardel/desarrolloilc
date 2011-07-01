class AddExternalFieldsToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :type, :integer
    add_column :orders, :extra, :float
    add_column :orders, :company_id, :integer
    add_column :orders, :external, :integer
  end

  def self.down
    remove_column :orders, :external
    remove_column :orders, :company_id
    remove_column :orders, :extra
    remove_column :orders, :type
  end
end
