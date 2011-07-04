# To change this template, choose Tools | Templates
# and open the template in the editor.

class Envios
  require 'soap/wsdlDriver'
  
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
    
    driver = SOAP::WSDLDriverFactory.new('http://'+@company.ip_address+'/WS/serviciowsdl.php?wsdl').create_rpc_driver

    email = "carlosdbm.ucab@gmail.com"
    c_o =@address.city
    c_d =@order.city
    urb = @order.zone
    calle = @order.street
    numero= @order.number
    lati = @order.latitude
    long = @order.longitude
    p = '4545303132330001'
    desc = @package.description
    pe = @package.weight.to_s



    response = driver.calcularcosto(email, c_o, c_d, urb, calle, numero, lati, long, p, desc, pe)

    puts "TOy aki"+response.to_s

    if response.to_s!="No hay servicio para esa zona" && response.to_s!="No se ha simulado el envio del paquete o no se encuentra registrado en la bd" && response.to_s!="Se dejaron campos vacios"

      @m=response.split('&')
      #@my=@m[0];
      
      total = 0
      for package in @order.packages
        total = package.price + total
      end
      total=total+(total*0.1)

      if @m[1].to_s>total.to_s
        @order.extra=@m[1].to_s
        @order.order_type=1
      end
      @order.external=@m[0].to_s
      @order.status=4
      @order.save

    
      @a = "Support request successfull. External id " + @m[0].to_s + " ,Price: " + @m[1].to_s
    else
      @a="Error: "+response.to_s
    end

    return @a
  end


  def solicitar_track_id (ord_id,comp)
    @company = Company.first(:conditions => ["id =?",comp])


    driver = SOAP::WSDLDriverFactory.new('http://'+@company.ip_address+'/WS/serviciowsdl.php?wsdl').create_rpc_driver

    response = driver.rastreoPaquete(ord_id.to_s)

    if response.to_s!="No se ha simulado el envio del paquete o no se encuentra registrado en la bd"
      puts "FUCK"+response.to_s

     
      @m=response.split(',')

  
      @a=""
      
      for i in 0..@m.length-1 do
        @a=@a+"<tr><td>&nbsp;</td><td>- Transit at "+@m[i]+"</td></tr>"
      end

      
      
    else
      @a=response.to_s
    end
    return @a
  end

  def solicitar_track_id2 (ord_id,comp)
    @company = Company.first(:conditions => ["id =?",comp])

    driver = SOAP::WSDLDriverFactory.new('http://'+@company.ip_address+'/WS/serviciowsdl.php?wsdl').create_rpc_driver

    response = driver.rastreoPaquete(ord_id.to_s)

    if response.to_s!="No se ha simulado el envio del paquete o no se encuentra registrado en la bd"
     
      @m=response.split(',')

      @a=""

      for i in 0..@m.length-1 do
        @a=@a+"Transit at "+@m[i]+" || "
      end

    else
      @a=response.to_s
    end
    return @a
  end

end