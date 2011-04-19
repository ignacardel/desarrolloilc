class Creditcard < ActiveRecord::Base

  #Validations
  validates_presence_of :number
  validates_presence_of :expdate
  validates_presence_of :code
  validates_presence_of :name

  validates_numericality_of :number
  validates_uniqueness_of :number
  validates_inclusion_of :number, :in => 1000000000..9999999999, :message=> 'Must have 10 digits'
  
  validates_numericality_of :code
  validates_inclusion_of :code, :in => 1000..9999, :message=> 'Must have 4 digits'
 

  
  #Relations
  
  belongs_to :client
  has_many :orders

  #Valida que la fecha de expiracion de la tarjeta
  #de credito sea mayor a la actual
  def validate
    errors.add(:expdate, "is invalid") if expdate < Date.today
  end
end
