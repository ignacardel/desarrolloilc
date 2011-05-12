class AddActiveToClients < ActiveRecord:: Migration
  def self.up
    add_column :clients ,:active, :integer
  end

  def self.down
    remove_column :clients ,:active, :integer
  end
end