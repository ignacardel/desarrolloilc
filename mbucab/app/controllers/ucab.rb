# To change this template, choose Tools | Templates
# and open the template in the editor.

class Ucab
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


    cliente_xml = '<client>mailboxesucab@gmail.com</client>'

    direccion_xml = '<address>ucabccs</address>'

    tarjeta_xml = '<creditcard>1234567890123456</creditcard>'


    orden_xml = '<order><city>'+@order.city+'</city>
                        <country>'+@order.country+'</country>
                        <name>'+@order.name+'</name>
                        <number>'+@order.number+'</number>
                        <recipient>'+@order.recipient+'</recipient>
                        <street>'+@order.street+'</street>
                        <zip>'+@order.zip.to_s+'</zip>
                        <zone>'+@order.zone+'</zone>
                 </order>'

    paquete_xml = '<package><description>'+@package.description+'</description>
                            <weight>'+@package.weight.to_s+'</weight>
                   </package>'

    #data variable donde va el xml
    info = cliente_xml + direccion_xml + tarjeta_xml + orden_xml + paquete_xml
    data ='<support_request>' + info + '</support_request>'

    # setea la informacion de la solicitud post

    uri = URI.parse("http://"+@company.ip_address+":3000/web_service/support_request")
    http = Net::HTTP.new(uri.host, uri.port)
    headers = { 'Content-Type'=>'application/xml', 'Content-Length'=>data.size.to_s }
    post = Net::HTTP::Post.new(uri.path, headers)
     
    begin
      response = http.request post, data

      xmlresponse = Hash.from_xml(response.body)

      case response
      when Net::HTTPCreated
        total = 0 
        for package in @order.packages 
          total = package.price + total 
        end
        total=total+(total*0.1)
        puts "EPALETOTAL"+total.to_s
        puts "EPALEEXTERNO"+xmlresponse["order"]["price"]
        if xmlresponse["order"]["price"]>total.to_s
          puts "ENTRE AL IF"
          @order.extra = xmlresponse["order"]["price"]
          @order.order_type = 1
        end
        @order.external = xmlresponse["order"]["order_id"]
        @order.status = 4
        @order.save
        @a = "Created a new order with id " + xmlresponse["order"]["order_id"].to_s + " ,extra charge: " +  xmlresponse["order"]["price"].to_s
      when Net::HTTPSuccess
        total = 0
        for packagex in @order.packages
          total = packagex.price + total
        end
        total=total+(total*0.1)
        puts "EPALETOTAL"+total.to_s
        puts "EPALEEXTERNO"+xmlresponse["order"]["price"]
        if xmlresponse["order"]["price"]>total.to_s
          puts "ENTRE AL IF"
          @order.extra = xmlresponse["order"]["price"]
          @order.order_type = 1
        end
        @order.external = xmlresponse["order"]["order_id"]
        @order.status = 4
        @order.save
        @a = "Support request successfull. External id " + xmlresponse["order"]["order_id"].to_s + " , Price: " +  xmlresponse["order"]["price"].to_s
      else response.error!
        @a = "respuesta rara"
      end
    rescue
      @a = "Connection error"
    end
    
    return @a
  end


  def solicitar_track_id (ord_id,comp)
    @company = Company.first(:conditions => ["id =?",comp])
    uri = URI.parse("http://"+@company.ip_address+":3000/web_service/track_id/"+ord_id.to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    headers = { 'Content-Type'=>'application/xml'}
    get = Net::HTTP::Get.new(uri.path, headers)
    begin
      response = http.request get

      xmlresponse = Hash.from_xml(response.body)

      case response
      when Net::HTTPOK
        status=xmlresponse["order"]["status"]
        if status=="Delivered"
          @a="<tr><td>&nbsp;</td><td>- "+xmlresponse["order"]["detail"]["address2"]+"</td></tr>"
        else
          @a="no ha llegado"
        end
      else response.error!
        @a = "no ha llegado"
      end
    rescue
      @a = "no ha llegado"
    end
    return @a
  end
end
