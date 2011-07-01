class AddIpToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :ip_address, :string
  end

  def self.down
    remove_column :companies, :ip_address
  end
end
