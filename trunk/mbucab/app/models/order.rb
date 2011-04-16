class Order < ActiveRecord::Base

  #Validations
  validates_presence_of :date
  validates_presence_of :recipient
  validates_presence_of :address




  #Relations
  has_many :packages
  belongs_to :client
  belongs_to :address
  belongs_to :creditcard
end