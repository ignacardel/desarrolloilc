class Client < ActiveRecord::Base

  #Validations
  validates_presence_of :account
  validates_presence_of :firstname
  validates_presence_of :lastname
  validates_presence_of :birthday
  validates_presence_of :phone

  validates_inclusion_of :phone, :in => 1000000..999999999, :message=> 'Must have 10 digits '
  validates_numericality_of :phone
  #Relations
  has_many :creditcards
  has_many :addresses
  has_many :orders
  
end
