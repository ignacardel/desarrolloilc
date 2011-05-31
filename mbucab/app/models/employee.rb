class Employee < ActiveRecord::Base

  #Validations

  validates_presence_of :account;
  validates_presence_of :password, :on => :create;
  validates_presence_of :name;
  validates_presence_of :lastname;
  validates_uniqueness_of :account;



  #Relations
  has_many :routes

  def actual_role
    case role
    when 1
      @actual_role = "Administrator"
    when 2
      @actual_role = "Mail Carrier"
    when 3
      @actual_role="Dispatcher"
    end
  end

  def fullname
    return name + ' ' + lastname
  end
  
end
