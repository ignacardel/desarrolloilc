class Client < ActiveRecord::Base

  #Validations
  validates_presence_of :account
  validates_presence_of :firstname
  validates_presence_of :lastname
  validates_presence_of :birthday
  validates_presence_of :phone

  validates_inclusion_of :phone, :in => 1000000..999999999, :message=> 'must have 7 digits'
  validates_numericality_of :phone
  #Relations
  has_many :creditcards
  has_many :addresses
  has_many :orders

  accepts_nested_attributes_for :addresses, :allow_destroy => true

  #El siguiente codigo permite definir el nombre que
  #un atributo mostrara en los mensajes de error del formulario

  HUMAN_ATTRIBUTES = {
    :phone => "Phone no."
    }

  def self.human_attribute_name(attr)
    HUMAN_ATTRIBUTES[attr.to_sym] || super
  end

end
