class Order < ActiveRecord::Base
  #Validations
  validates_presence_of :address_id , :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :recipient , :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :latitude, :message=> 'must be set by picking a location in the map'
  validates_presence_of :street, :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :name, :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :number, :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :zone, :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :city, :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :country, :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :zip, :if => lambda { |o| o.current_step == "packages" }


  validates_numericality_of :zip,:greater_than => 0

  #type 0 = Apoyo a otra empresa , 1 = solicitud , 2 = aceptado, 3 = rechazado

  #Relations
  has_many :packages
  belongs_to :client
  belongs_to :address
  belongs_to :creditcard

  #El siguiente codigo permite definir el nombre que
  #un atributo mostrara en los mensajes de error del formulario

  HUMAN_ATTRIBUTES = {
    :latitude => "Address coordinates",
    :street    => "Avenue/Street",
    :name => "Residence/House name",
    :number => "Apartment/House number",
    :zone => "Urbanization",
    :zip => "Zip code",
    :nickname => "Unique address nickname",
    :address_id => "Pickup address"
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
      @actual_status = "Pickup complete"
    when 2
      @actual_status = "Assigned for pickup"
    when 3
      @actual_status = "Delivered"
    when 4
      @actual_status = "Waiting for pickup"
    end

  end

  def fulladdress
    @fulladdress=street+" "+name+" "+number.to_s+", "+zone+", "+city+" "+zip.to_s+", "+country
  end

end
