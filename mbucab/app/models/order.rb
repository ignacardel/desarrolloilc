class Order < ActiveRecord::Base
  #Validations
  validates_presence_of :recipient , :if => lambda { |o| o.current_step == "packages" }
  validates_presence_of :fulladdress , :if => lambda { |o| o.current_step == "packages" }




  #Relations
  has_many :packages
  belongs_to :client
  belongs_to :address
  belongs_to :creditcard

  accepts_nested_attributes_for :packages,  :allow_destroy => true

  attr_writer :current_step

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
      @actual_status = "Waiting"
     when 1
      @actual_status = "Collected"
    end
   
  end

end