class Creditcard < ActiveRecord::Base

  #Validations
  validates_presence_of :number
  validates_presence_of :expdate
  validates_presence_of :code
  validates_presence_of :name

  validates_numericality_of :number
  validates_uniqueness_of :number
  validates_inclusion_of :number, :in => 1000000000000000..9999999999999999, :message=> 'is invalid'
  
  validates_numericality_of :code
  validates_inclusion_of :code, :in => 100..999, :message=> 'must have 3 digits'
 

  
  #Relations
  
  belongs_to :client
  has_many :orders

  #El siguiente codigo permite definir el nombre que
  #un atributo mostrara en los mensajes de error del formulario

  HUMAN_ATTRIBUTES = {
    :name => "Cardholder's Name",
    :number => "Credit card number",
    :expdate => "Card expiration date",
    :code => "Security code"

  }

  def self.human_attribute_name(attr)
    HUMAN_ATTRIBUTES[attr.to_sym] || super
  end
  
  #Valida que la fecha de expiracion de la tarjeta
  #de credito sea mayor a la actual
  def validate
    errors.add(:expdate, "has passed") if expdate.month < Date.current.month
  end

  #Metodo que imprime solo los ultimos 4 digitos de la tarjeta
  def four_numbers
    @four_numbers = "**********" + number.to_s.from(12)
  end
end
