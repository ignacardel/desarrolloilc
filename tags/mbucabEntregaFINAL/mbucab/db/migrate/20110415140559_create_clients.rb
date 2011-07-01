class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :account
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :surname
      t.date :birthday
      t.integer :phone

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
