require File.dirname(__FILE__) + '/../test_helper'
require 'employees_controller'

class EmployeesControllerTest < ActionController::TestCase
  fixtures :employees

  def setup
    @controller = EmployeesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_employee
    get(:index , { 'id' => employees(:borjas).id}, { 'role' => employees(:borjas).role})
    assert_template 'employees/index.html.erb'
  end

  def test_invalid_role_index_employee
    get(:index , { 'id' => employees(:sol).id}, { 'role' => employees(:sol).role})
    assert_redirected_to :controller => 'operations', :action => 'index'
  end

  def teardown
    @controller = nil
    @request = nil
    @response = nil
  end
end
