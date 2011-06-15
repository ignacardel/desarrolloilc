require File.dirname(__FILE__) + '/../test_helper'
#'test_helper'

class OrderTest < ActiveSupport::TestCase

  fixtures :orders

    def test_order

      # crea un objeto orden con los datos de la orden en el archivo yml
      order = Order.new :recipient => orders(:testorder).recipient,
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
                            :zip => orders(:testorder).zip


      # verifica si el objeto se guarda bien si no la prueba falla
      assert order.save

      perl_book_copy = Order.find(order.id)

      #vuelve a buscar el objeto guardado en la base de datos y verifica que sea
      # igual al que se intento guardar

      assert_equal order.recipient, perl_book_copy.recipient

      order.recipient = "recipient nuevo"

      #hace un cambio en el destinatario y vuelve a guardar el objeto
      assert order.save

      # elimina el objeto si no se elimina bien la prueba falla
      assert order.destroy
      
    end
  # Replace this with your real tests.
 #  test "the truth" do
 #    assert true
 #  end
end
