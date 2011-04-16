class Address < ActiveRecord::Base
  
  #Validations
  validates_presence_of :street
  validates_presence_of :name
  validates_presence_of  :number
  validates_presence_of  :zone
  validates_presence_of  :city
  validates_presence_of  :country
  validates_presence_of  :zip
  validates_presence_of  :nickname
  validates_presence_of :latitude, :longitude, :message=> 'must be set by picking a location in the map'


  validates_numericality_of :zip,:greater_than => 0

  validates_numericality_of :number

  #validar nick pero para el solo

  #Relations
  belongs_to :client
  has_many :orders
end
