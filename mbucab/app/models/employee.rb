class Employee < ActiveRecord::Base

  #Validations

  validates_presence_of :account;
  validates_presence_of :password;
  validates_presence_of :name;
  validates_presence_of :lastname;
  validates_presence_of :role;

  validates_uniqueness_of :account;



  #Relations
  
end
