class AddAddressfieldsToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :street, :string
    add_column :orders, :name, :string
    add_column :orders, :number, :integer
    add_column :orders, :zone, :string
    add_column :orders, :city, :string
    add_column :orders, :country, :string
    add_column :orders, :zip, :integer
  end

  def self.down
    remove_column :orders, :zip
    remove_column :orders, :country
    remove_column :orders, :city
    remove_column :orders, :zone
    remove_column :orders, :number
    remove_column :orders, :name
    remove_column :orders, :street
  end
end
