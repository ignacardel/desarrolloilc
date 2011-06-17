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

      cliente =  clients(:usuario).account
               
      direccion = 'micasa'

      tarjeta = 1234567890123456

        orden =   {         :recipient => orders(:testorder).recipient,
                            :street => orders(:testorder).street,
                            :name => orders(:testorder).name,
                            :number => orders(:testorder).number,
                            :zone => orders(:testorder).zone,
                            :city => orders(:testorder).city,
                            :country => orders(:testorder).country,
                            :zip => orders(:testorder).zip}


      paquete = {           :description => packages(:two).description,
                            :weight => packages(:two).weight}




      parametros = {'client'=> cliente, 'address' => direccion, 'creditcard' => tarjeta, 'order' => orden, 'package' => paquete}
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
