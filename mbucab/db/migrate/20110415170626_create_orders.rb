class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.datetime :date
      t.string :recipient
      t.string :address
      t.float :longitude
      t.float :latitude
      t.integer :status
      t.datetime :collectiondate
      t.datetime :deliverydate
      t.integer :address_id
      t.integer :client_id
      t.integer :creditcard_id

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
