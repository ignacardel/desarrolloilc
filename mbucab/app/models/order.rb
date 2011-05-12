class Order < ActiveRecord::Base
  #Validations
  validates_presence_of :recipient , :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :fulladdress , :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :latitude, :message=> 'must be set by picking a location in the map'



  #Relations
  has_many :packages
  belongs_to :client
  belongs_to :address
  belongs_to :creditcard

  #El siguiente codigo permite definir el nombre que
  #un atributo mostrara en los mensajes de error del formulario

  HUMAN_ATTRIBUTES = {
    :latitude => "Address coordinates"
  }

  def self.human_attribute_name(attr)
    HUMAN_ATTRIBUTES[attr.to_sym] || super
  end
  accepts_nested_attributes_for :packages,  :allow_destroy => true

  attr_writer :current_step

  #Los siguientes metodos controlan la logica del formulario
  #por pasos cuando se crea una nueva orden.
  def current_step
    @current_step || steps.first    
  end

  def steps
    %w[packages payment confirmation]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def back_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end
  
  def actual_status

    case status
    when 0
      @actual_status = "Waiting for pickup"
    when 1
      @actual_status = "Pickup complete."
    end
   
  end

end
