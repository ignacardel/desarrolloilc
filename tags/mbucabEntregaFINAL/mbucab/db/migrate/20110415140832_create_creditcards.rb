class CreateCreditcards < ActiveRecord::Migration
  def self.up
    create_table :creditcards do |t|
      t.integer :number
      t.date :expdate
      t.integer :code
      t.string :name
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :creditcards
  end
end
