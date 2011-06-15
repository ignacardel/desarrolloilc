require File.dirname(__FILE__) + '/../test_helper'
require 'web_service_controller'

class WebServiceControllerTest < ActionController::TestCase
  # Replace this with your real tests.
    def setup # inicia el controlador y las clases que se necesitan para porbar con request http
     @controller = WebServiceController.new
     @request    = ActionController::TestRequest.new
     @response   = ActionController::TestResponse.new
    end

    def test_support_request

      #prueba el metodo support_reques que sirve para recibir peticiones de soporte
      #primero setea la informacion que se le debe pasar como xml
      #manda la peticion post al controlador con toda la info de cliente y orden
      #luego prueba que client, orden, paquete, tarjeta y direccion esten bien seteados
      #verifica que la respuesta de la peticion sea succes y se haya creado bien la solicitud de apoyo
      #por ultimo verifica que la vista renderizada sea la respuesta en xml para el web_service

      cliente = {'account' => clients(:usuario).account,
                 'firstname' => clients(:usuario).firstname,
                 'middlename' => clients(:usuario).middlename,
                 'lastname' => clients(:usuario).lastname,
                 'surname' => clients(:usuario).surname,
                 'birthday' => clients(:usuario).birthday ,
                 'phone' => clients(:usuario).phone}
               
      direccion = {'city' => 'Caracas',
                   'country' => 'Venezuela',
                   'latitude' => 10.4493563318414,
                   'longitude' => -66.8719526074219,
                   'name' => 'edi prueba',
                   'nickname' => 'Mi Casa',
                   'number' => '1',
                   'street' =>'calle prueba',
                   'zip' => 1023,
                   'zone' => 'PRUEBAS'}

      tarjeta = {'code' => 111,
                 'expdate' => '2013-05-01',
                 'name' => 'Senor Prueba',
                 'number' => 5555555555555555}

        orden =   {         :recipient => orders(:testorder).recipient,
                            :longitude => orders(:testorder).longitude,
                            :latitude => orders(:testorder).latitude,
                            :status => orders(:testorder).status,
                            :collectiondate => orders(:testorder).collectiondate,
                            :deliverydate => orders(:testorder).deliverydate,
                            :address_id => orders(:testorder).address_id,
                            :client_id => orders(:testorder).client_id,
                            :creditcard_id => orders(:testorder).creditcard_id,
                            :date => orders(:testorder).date,
                            :street => orders(:testorder).street,
                            :name => orders(:testorder).name,
                            :number => orders(:testorder).number,
                            :zone => orders(:testorder).zone,
                            :city => orders(:testorder).city,
                            :country => orders(:testorder).country,
                            :zip => orders(:testorder).zip}


      paquete = {           :description => packages(:two).description,
                            :weight => packages(:two).weight}




      parametros = {'client'=> cliente, 'address' => direccion, 'creditcard' => tarjeta, 'order' => orden, 'total' => 15, 'package' => paquete}
      post(:support_request,{'support_request' => parametros})
      assert_not_nil assigns(:client)
      assert_not_nil assigns(:address)
      assert_not_nil assigns(:creditcard)
      assert_not_nil assigns(:order)
      assert_not_nil assigns(:package)
      assert_response :success
      assert_template "web_service/support_request.xml.builder"
     
    end

    def teardown
      @controller = nil
      @request = nil
      @response = nil
    end

end
