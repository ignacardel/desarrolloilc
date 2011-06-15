#require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'
require 'clients_controller'

#class ClientController
#   def rescue_action(e)
#      raise e
#   end
#end


class ClientsControllerTest < ActionController::TestCase
  fixtures :clients

  def setup # inicia el controlador y las clases que se necesitan para porbar con request http
    @controller = ClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new


  end

  def test_show_client

    # prueba el metodo show client y pasa parametros al session y params
    # luego prueba que el cliente se consiga y se guarde bien en la variable client
    # prueba que el account del client a buscar sea el esperado
    get(:show, {'id' => 1}, {'id' => 1,'user' => clients(:usuario).account })
    assert_not_nil assigns(:client)
    assert_equal clients(:usuario).account, 'usuario@prueba.com'
    
  end


    def test_create_client

    # prueba el metodo de create client y pasa todo un hash con los atributos del nuevo client
    # prueba que el cliente se cree bien y se le asigne los parametros del hash
    # luego se prueba que los datos sean correctos comprando el account nuevo con el asignado
    # luego se verifica que se le asigne bien el estado en active
    # verifica que se setee el mensaje de flash cuando se cree el usuario nuevo
    
    c = {'account' => clients(:usuario).account, 'firstname' => clients(:usuario).firstname,
         'middlename' => clients(:usuario).middlename, 'lastname' => clients(:usuario).lastname,
         'surname' => clients(:usuario).surname, 'birthday' => clients(:usuario).birthday ,
         'phone' => clients(:usuario).phone}




    post(:create, {'client' => c})
    assert_not_nil assigns(:client)
    assert_equal assigns(:client).account, clients(:usuario).account
    assert_equal assigns(:client).active,1
    assert_equal 'You have successfully registered!', flash[:notice]

  end

    def teardown
      @controller = nil
      @request = nil
      @response = nil
    end
  
end
