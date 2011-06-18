class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :account
      t.string :password
      t.string :name
      t.string :lastname
      t.integer :role

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
