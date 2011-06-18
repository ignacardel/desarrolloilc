class Route < ActiveRecord::Base
  #Relations
  has_many :orders
  belongs_to :employee
  
  validates_presence_of :employee_id, :message=> 'must be assigned'

  HUMAN_ATTRIBUTES = {
    :employee_id => "Carrier"
  }

  def self.human_attribute_name(attr)
    HUMAN_ATTRIBUTES[attr.to_sym] || super
  end
end
