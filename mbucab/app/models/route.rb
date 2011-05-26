class Route < ActiveRecord::Base
  #Relations
  has_many :orders
  belongs_to :employee
end
