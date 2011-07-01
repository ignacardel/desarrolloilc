class Package < ActiveRecord::Base

  #Validations
  validates_presence_of :description
  validates_presence_of :weight

  validates_numericality_of :weight, :greater_than => 0.0
  validates_numericality_of :price

  

  #Relations
    belongs_to :order
end
