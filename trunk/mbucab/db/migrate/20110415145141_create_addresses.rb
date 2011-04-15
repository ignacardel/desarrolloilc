class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street
      t.string :name
      t.integer :number
      t.string :zone
      t.string :city
      t.string :country
      t.integer :zip
      t.float :latitude
      t.float :longitude
      t.string :nickname
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
