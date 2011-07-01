class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.string :description
      t.float :weight
      t.float :price
      t.integer :order_id

      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end
