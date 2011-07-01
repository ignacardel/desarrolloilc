class AddReasonToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :reason, :string
  end

  def self.down
    remove_column :orders, :reason
  end
end
