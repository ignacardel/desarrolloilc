require File.dirname(__FILE__) + '/../test_helper'
require 'addresses_controller'

class AddressesControllerTest < ActionController::TestCase
  fixtures :addresses

  def setup
    @controller = AddressesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_show_address
    get(:show, {'id' => 2}, {'id' => 1, 'user' => 'usuario@prueba.com' })
    assert_not_nil assigns(:address)
    assert_equal addresses(:home).nickname, assigns(:address).nickname
    assert_template 'addresses/show.html.erb'
  end

#  def test_create_address
#    a = {'street' => addresses(:home).street,
#          'name' => addresses(:home).name,
#          'number' => addresses(:home).number,
#          'zone' => addresses(:home).zone,
#          'city' => addresses(:home).city,
#          'country' => addresses(:home).country,
#          'zip' => addresses(:home).zip,
#          'latitude' => addresses(:home).latitude,
#          'longitude' => addresses(:home).longitude,
#          'nickname' => 'perra',
#          'client_id' => addresses(:home).client_id}
#
#    post(:create, nil, {'id' => 1, 'user' => 'usuario@prueba.com'})
#    assert_assign assigns(:address).nickname, 'perra'
#    assert_equal 'Address was successfully created.', flash[:notice]
#  end

  def teardown
    @controller = nil
    @request = nil
    @response = nil
  end
end
