require File.dirname(__FILE__) + '/../test_helper'
require 'creditcards_controller'

class CreditcardsControllerTest < ActionController::TestCase
  fixtures :creditcards

  def setup
    @controller = CreditcardsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_show_creditcard
    get(:show, {'id' => 2}, {'id' => 1, 'user' => 'usuario@prueba.com' })
    assert_not_nil assigns(:creditcard)
    assert_equal creditcards(:visa).name, assigns(:creditcard).name
    assert_valid assigns(:creditcard)
    assert_template 'creditcards/show.html.erb'
  end

  def teardown
    @controller = nil
    @request = nil
    @response = nil
  end
end
