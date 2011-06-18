require File.dirname(__FILE__) + '/../test_helper'
#require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  # Replace this with your real tests.




    fixtures :clients

    def test_client

      # crea un objeto orden con los datos de la orden en el archivo yml
    client = Client.new  :id => clients(:usuario).id,
                          :account => clients(:usuario).account,
                          :firstname => clients(:usuario).firstname,
                          :middlename => clients(:usuario).middlename,
                          :lastname => clients(:usuario).lastname,
                          :surname => clients(:usuario).surname,
                          :birthday => clients(:usuario).birthday,
                          :phone => clients(:usuario).phone,
                          :active => clients(:usuario).active
                       


      # verifica si el objeto se guarda bien si no la prueba falla
      assert client.save

      perl_book_copy = Client.find(client.id)

      #vuelve a buscar el objeto guardado en la base de datos y verifica que sea
      # igual al que se intento guardar

      assert_equal client.account, perl_book_copy.account

      client.account = "nuevo@correo.com"

      #hace un cambio en el destinatario y vuelve a guardar el objeto
      assert client.save

      # elimina el objeto si no se elimina bien la prueba falla
      assert client.destroy

    end
#  test "the truth" do
#    assert true
#  end
end
