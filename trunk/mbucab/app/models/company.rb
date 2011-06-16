class Company < ActiveRecord::Base
  validates_presence_of :name;
  validates_presence_of :rif;
  validates_presence_of :phone;
  validates_presence_of :fax;
  validates_presence_of :address;
  validates_presence_of :ip_address;

  validates_size_of :phone, :is => 10, :message=> 'must have 10 digits'
  validates_numericality_of :phone

  validates_size_of :fax, :is => 10, :message=> 'must have 10 digits'
  validates_numericality_of :fax

  validates_size_of :rif, :is => 9, :message=> 'must have 9 digits'
  validates_numericality_of :rif
end
