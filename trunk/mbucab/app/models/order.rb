class Order < ActiveRecord::Base
  #Validations
  validates_presence_of :recipient
  validates_presence_of :fulladdress




  #Relations
  has_many :packages
  belongs_to :client
  belongs_to :address
  belongs_to :creditcard

  accepts_nested_attributes_for :packages,  :allow_destroy => true
end
