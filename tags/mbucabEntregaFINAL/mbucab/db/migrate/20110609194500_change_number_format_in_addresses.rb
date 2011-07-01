class ChangeNumberFormatInAddresses < ActiveRecord::Migration
  def self.up
    change_column :addresses, :number, :string
  end

  def self.down
    change_column :addresses, :number, :integer
  end
end
