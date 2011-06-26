# To change this template, choose Tools | Templates
# and open the template in the editor.

class Postit
  def initialize
    
  end

    def solicitar_servicio (ord_id,comp)

    @company = Company.first(:conditions => ["id =?",comp])
    @order = Order.first(:conditions => ["id =?",ord_id])
    @order.company_id = comp

    @client = Client.first(:conditions => ["id =?", @order.client_id])
    @creditcard = Creditcard.first(:conditions => ["id =?",  @order.creditcard_id])
    @address = Address.first(:conditions => ["id =?", @order.address_id])
    @package = Package.first(:conditions => ["order_id =?", @order.id])


    cliente_xml = '<UserEmail>mailboxesucab</UserEmail>' #correo sin @gmail.com

    origen_xml = '<Origin><Alias>ucabccs</Alias></Origin>'

    receptor_xml =  '<ReceiverName>'+@order.recipient+'</ReceiverName>'

    destino_xml = '<Destiny><City>'+@order.city+'</City>
                          <Country>'+@order.country+'</Country>
                          <Street>'+@order.street+'</Street>
                          <ZipCode>'+@order.zip.to_s+'</ZipCode>
                          <HouseName>'+@order.name+'</HouseName>
                          <HouseNumber>'+@order.number+'</HouseNumber>
                 </Destiny>'

    paquete_xml = '<Packages><Package>
                             <Content>'+@package.description+'</Content>
                             <Height>1</Height>
                             <Thicknes>1</Thicknes>
                             <weight>'+@package.weight.to_s+'</weight>
                             <Width>1</Width>
                   </Package></Packages>'

    orden_xml = '<Order>'+ destino_xml + origen_xml + paquete_xml + receptor_xml +'</Order>'

    info = orden_xml + cliente_xml


    data ='<SupportRequest>' + info + '</SupportRequest>'

     # setea la informacion de la solicitud post

     uri = URI.parse("http://"+@company.ip_address+"/PostIt/API/Order/Create")


     http = Net::HTTP.new(uri.host, uri.port)
     headers = { 'Content-Type'=>'application/xml', 'Content-Length'=>data.size.to_s }
     post = Net::HTTP::Post.new(uri.path, headers)

     begin
          response = http.request post, data

          xmlresponse = Hash.from_xml(response.body)

          case response
            when Net::HTTPCreated
              @order.extra = xmlresponse["OrderRequestResult"]["Price"]
              @order.order_type = 1
              @order.external = xmlresponse["OrderRequestResult"]["Tracking"]
              @order.status = 4
              @order.save
              @a = "Created a new order with id " + xmlresponse["OrderRequestResult"]["Tracking"].to_s + " ,extra charge: " +  xmlresponse["OrderRequestResult"]["Price"].to_s
            when Net::HTTPSuccess
              @order.extra = xmlresponse["OrderRequestResult"]["Price"]
              @order.order_type = 1
              @order.external = xmlresponse["OrderRequestResult"]["Tracking"]
              @order.status = 4
              @order.save
              @a = "Succes a new order with id " + xmlresponse["OrderRequestResult"]["Tracking"].to_s + " ,extra charge: " +  xmlresponse["OrderRequestResult"]["Price"].to_s
            else response.error!
              @a = "Error " + xmlresponse["OrderRequestResult"]["ErrorCode"]
          end
     rescue
       @a = "hubo un error de conexion"
     end

    return @a
  end


  def solicitar_track_id (ord_id,comp)

  end


end
