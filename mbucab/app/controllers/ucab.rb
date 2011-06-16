# To change this template, choose Tools | Templates
# and open the template in the editor.

class Ucab
  def initialize
    
  end


  def solicitar_servicio (ord_id,comp)

    @order = Order.first(:conditions => ["id =?",ord_id])
    @order.company_id = comp
    
    @client = Client.first(:conditions => ["id =?", @order.client_id])
    @creditcard = Creditcard.first(:conditions => ["id =?",  @order.creditcard_id])
    @address = Address.first(:conditions => ["id =?", @order.address_id])
    @package = Package.first(:conditions => ["order_id =?", @order.id])


    cliente_xml = '<client><account>'+@client.account+'</account>
                          <birthday>'+@client.birthday.to_s+'</birthday>
                          <firstname>'+@client.firstname+'</firstname>
                          <lastname>'+@client.lastname+'</lastname>
                          <middlename>'+@client.middlename+'</middlename>
                          <phone>'+@client.phone.to_s+'</phone>
                          <surname>'+@client.surname+'</surname>
                  </client>'

    direccion_xml = '<address><city>'+@address.city+'</city>
                          <country>'+@address.country+'</country>
                          <latitude>'+@address.latitude.to_s+'</latitude>
                          <longitude>'+@address.longitude.to_s+'</longitude>
                          <name>'+@address.name+'</name>
                          <nickname>'+@address.nickname+'</nickname>
                          <number>'+@address.number.to_s+'</number>
                          <street>'+@address.street+'</street>
                          <zip>'+@address.zip.to_s+'</zip>
                          <zone>'+@address.zone+'</zone>
                 </address>'

    tarjeta_xml = '<creditcard><code>'+@creditcard.code.to_s+'</code>
                               <expdate>'+@creditcard.expdate.to_s+'</expdate>
                               <name>'+@creditcard.name+'</name>
                               <number>'+@creditcard.number.to_s+'</number>
                   </creditcard>'


    orden_xml = '<order><city>'+@order.city+'</city>
                        <country>'+@order.country+'</country>
                        <latitude>'+@order.latitude.to_s+'</latitude>
                        <longitude>'+@order.longitude.to_s+'</longitude>
                        <name>'+@order.name+'</name>
                        <number>'+@order.number+'</number>
                        <recipient>'+@order.recipient+'</recipient>
                        <street>'+@order.street+'</street>
                        <zip>'+@order.zip.to_s+'</zip>
                        <zone>'+@order.zone+'</zone>
                 </order>'

    total = '<total>'+@package.price.to_s+'</total>'

    paquete_xml = '<package><description>'+@package.description+'</description>
                            <weight>'+@package.weight.to_s+'</weight>
                   </package>'




    #data variable donde va el xml
    info = cliente_xml + direccion_xml + tarjeta_xml + orden_xml + total + paquete_xml
    data ='<support_request>' + info + '</support_request>'

     # setea la informacion de la solicitud post
     uri = URI.parse("http://192.168.20.217:3000/web_service/support_request")
     http = Net::HTTP.new(uri.host, uri.port)
     headers = { 'Content-Type'=>'application/xml', 'Content-Length'=>data.size.to_s }
     post = Net::HTTP::Post.new(uri.path, headers)
     
     begin
          response = http.request post, data

          xmlresponse = Hash.from_xml(response.body)

          case response
            when Net::HTTPCreated
              @order.extra = xmlresponse["order"]["price"]
              @order.order_type = 1
              @order.external = xmlresponse["order"]["order_id"]
              @order.status = 4
              @order.save
              @a = "Created a new order with id " + xmlresponse["order"]["order_id"].to_s + " ,extra charge: " +  xmlresponse["order"]["price"].to_s
            when Net::HTTPSuccess
              @order.extra = xmlresponse["order"]["price"]
              @order.order_type = 1
              @order.external = xmlresponse["order"]["order_id"]
              @order.status = 4
              @order.save
              @a = "Succes a new order with id " + xmlresponse["order"]["order_id"].to_s + " ,extra charge: " +  xmlresponse["order"]["price"].to_s
            else response.error!
              @a = "respuesta rara"
          end
     rescue
       @a = "hubo un error de conexion"
     end
    
    return @a
  end


  def solicitar_track_id (ord_id,comp)

  end
end
