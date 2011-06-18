require File.dirname(__FILE__) + '/../test_helper'

#require 'test_helper'

class AddressTest < ActiveSupport::TestCase


  fixtures :addresses

  def test_address

    address = Address.new :street => addresses(:home).street,
                          :name => addresses(:home).name,
                          :number => addresses(:home).number,
                          :zone => addresses(:home).zone,
                          :city => addresses(:home).city,
                          :country => addresses(:home).country,
                          :zip => addresses(:home).zip,
                          :latitude => addresses(:home).latitude,
                          :longitude => addresses(:home).longitude,
                          :nickname => "MyString",
                          :client_id => addresses(:home).client_id
    assert !address.save

    address.nickname = "Mi casita"

    assert address.save

    address_copy = Address.find(address.id)

    assert_equal address.zip, address_copy.zip

    address.nickname = "Mi Casita Nueva"

    assert address.save
    assert address.destroy
  end
end
