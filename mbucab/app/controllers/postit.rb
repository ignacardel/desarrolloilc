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

    origen_xml = '<d2p1:Origin><d2p1:Alias>ucabccs</d2p1:Alias></d2p1:Origin>'

    receptor_xml =  '<d2p1:ReceiverName>'+@order.recipient+'</d2p1:ReceiverName>'

    destino_xml = '<d2p1:Destiny>
                          <d2p1:Alias>Entrega</d2p1:Alias>
                          <d2p1:City>'+@order.city+'</d2p1:City>
                          <d2p1:Country>'+@order.country+'</d2p1:Country>
                          <d2p1:Street>'+@order.street+'</d2p1:Street>
                          <d2p1:ZipCode>'+@order.zip.to_s+'</d2p1:ZipCode>
                          <d2p1:HouseName>'+@order.name+'</d2p1:HouseName>
                          <d2p1:HouseNumber>'+@order.number+'</d2p1:HouseNumber>
                 </d2p1:Destiny>'

    paquete_xml = '<d2p1:Packages><d2p1:Package>
                             <d2p1:Content>'+@package.description+'</d2p1:Content>
                             <d2p1:Height>1</d2p1:Height>
                             <d2p1:Thicknes>1</d2p1:Thicknes>
                             <d2p1:Weight>'+@package.weight.to_s+'</d2p1:Weight>
                             <d2p1:Width>1</d2p1:Width>
                   </d2p1:Package></d2p1:Packages>'

    orden_xml = '<Order xmlns:d2p1="http://schemas.datacontract.org/2004/07/PostIt.Models.Core">'+ destino_xml + origen_xml + paquete_xml + receptor_xml +'</Order>'

    info = orden_xml + cliente_xml


    data ='<SupportRequest xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.datacontract.org/2004/07/PostIt.Models.Adapter.PostIt">' + info + '</SupportRequest>'

    puts "JABIBIIII"
    puts data
    # setea la informacion de la solicitud post

    uri = URI.parse("http://"+@company.ip_address+"/PostIt/API/Order/Create")


    http = Net::HTTP.new(uri.host, uri.port)
    headers = { 'Content-Type'=>'text/xml', 'Content-Length'=>data.size.to_s }
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
        puts "EPALEEXTERNO"+xmlresponse["OrderRequestResult"]["Price"]
        if xmlresponse["OrderRequestResult"]["Price"]>total.to_s
          puts "ENTRE AL IF"
          @order.extra = xmlresponse["OrderRequestResult"]["Price"]
          @order.order_type = 1
        end
        @order.external = xmlresponse["OrderRequestResult"]["Tracking"]
        @order.status = 4
        @order.save
        @a = "Created a new order with id " + xmlresponse["OrderRequestResult"]["Tracking"].to_s + " ,extra charge: " +  xmlresponse["OrderRequestResult"]["Price"].to_s
      when Net::HTTPSuccess
        total = 0
        for packagex in @order.packages
          total = packagex.price + total
        end
        total=total+(total*0.1)
        puts "EPALETOTAL"+total.to_s
        puts "EPALEEXTERNO"+xmlresponse["OrderRequestResult"]["Price"]
        if xmlresponse["OrderRequestResult"]["Price"]>total.to_s
          puts "ENTRE AL IF"
          @order.extra = xmlresponse["OrderRequestResult"]["Price"]
          @order.order_type = 1
        end
        @order.external = xmlresponse["OrderRequestResult"]["Tracking"]
        @order.status = 4
        @order.save
        @a = "Support request successfull. External id " + xmlresponse["OrderRequestResult"]["Tracking"].to_s + " ,Price: " +  xmlresponse["OrderRequestResult"]["Price"].to_s
      else response.error!
        @a = "Error " + xmlresponse["OrderRequestResult"]["ErrorCode"]
      end
    rescue
      @a = "Connection error"
    end

    return @a
  end


  def solicitar_track_id (ord_id,comp)
    @company = Company.first(:conditions => ["id =?",comp])
    #    uri = URI.parse("http://"+@company.ip_address+"/PostIt/API/Order/GetStops?OrderTracking="+ord_id.to_s)
    #    http = Net::HTTP.new(uri.host, uri.port)
    #    headers = { 'Content-Type'=>'text/xml'}
    #    get = Net::HTTP::Get.new(uri.path, headers)

    xml_result_set = Net::HTTP.get_response(URI.parse("http://"+@company.ip_address+"/PostIt/API/Order/GetStops?OrderTracking="+ord_id.to_s))

    xml_result_set2 = Net::HTTP.get_response(URI.parse("http://"+@company.ip_address+"/PostIt/API/Order/GetStatus?OrderTracking="+ord_id.to_s))

   
    begin

      xmlresponse2=Hash.from_xml(xml_result_set2.body)
      if xmlresponse2["RequestResult"]["Message"]=="Entregada"
        
        @a=""
        xmlresponse = Hash.from_xml(xml_result_set.body)
        
        xmlresponse["ArrayOfStop"]["Stop"].each do |key,value|
          puts key["Alias"]
          puts key["City"]
          puts key["Country"]
          puts key["State"]
          @a=@a+"<tr><td>&nbsp;</td><td>- Transit at "+key["Alias"]+","+key["City"]+","+key["State"]+","+key["Country"]+"</td></tr>"
        end
      else
        @a = "no ha llegado"
      end


    rescue Exception => e
      @a = "no ha llegado"
      puts 'Connection error: ' + e.message
    end
    return @a
  end

  def solicitar_track_id2 (ord_id,comp)
    @company = Company.first(:conditions => ["id =?",comp])
    #    uri = URI.parse("http://"+@company.ip_address+"/PostIt/API/Order/GetStops?OrderTracking="+ord_id.to_s)
    #    http = Net::HTTP.new(uri.host, uri.port)
    #    headers = { 'Content-Type'=>'text/xml'}
    #    get = Net::HTTP::Get.new(uri.path, headers)

    xml_result_set = Net::HTTP.get_response(URI.parse("http://"+@company.ip_address+"/PostIt/API/Order/GetStops?OrderTracking="+ord_id.to_s))

    xml_result_set2 = Net::HTTP.get_response(URI.parse("http://"+@company.ip_address+"/PostIt/API/Order/GetStatus?OrderTracking="+ord_id.to_s))


    begin

      xmlresponse2=Hash.from_xml(xml_result_set2.body)
      if xmlresponse2["RequestResult"]["Message"]=="Entregada"

        @a=""
        xmlresponse = Hash.from_xml(xml_result_set.body)

        xmlresponse["ArrayOfStop"]["Stop"].each do |key,value|
          puts key["Alias"]
          puts key["City"]
          puts key["Country"]
          puts key["State"]
          @a=@a+"Transit at "+key["Alias"]+","+key["City"]+","+key["State"]+","+key["Country"]+"||"
        end
      else
        @a = "no ha llegado"
      end


    rescue Exception => e
      @a = "no ha llegado"
      puts 'Connection error: ' + e.message
    end
    return @a
  end


end
