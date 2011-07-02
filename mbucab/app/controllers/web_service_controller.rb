class WebServiceController < ApplicationController
  layout 'operationsmapmarker'
  require 'uri'
  require 'net/https'
  require 'open-uri'


  skip_before_filter :check_request_exception # filter the plugin installed

  

  def new_support_request #manda POST
    ord_id = params[:order_support_request_id]
    comp = params[:company_support_request_id]
    Order.update_all(["reason=?",params[:reason]],:id=>params[:order_support_request_id])
    case comp
    when "2"   #mbucab
      u = Ucab.new
      @a = u.solicitar_servicio(ord_id, comp)
    when "3"   #PostIt
      u = Postit.new
      @a = u.solicitar_servicio(ord_id, comp)
    end

    render "show"
  end

  def new_track_id_request


    # aqui se llama a la clase que tenga el metodo correcto para cada empresa.
    #esto es para consultar el track_id a otra empresa por web_Service
  end


  def track_id


    @error = true
    if re = request_exception
      re_name = re.name.to_s
    end

    #falta validar si la orden esta en la otra compania con el status 4

    @order = Order.first(:conditions => ["id =?", params[:id]])
    if @order and params[:id] != nil
      # hacer que solo muestre el detail dependiendo del status

      a0 = "Assigned for Pickup"
      a1 = "Arrival at Montalban UCAB Office"
      a2 = "Arrival at Los Teques UCAB Office"
      a3 = "Arrival at San Ignacio UCAB Office"

      if (@order.id.to_s.end_with?("0") || @order.id.to_s.end_with?("3") || @order.id.to_s.end_with?("6") || @order.id.to_s.end_with?("9"))
        sede = a1 end
      if (@order.id.to_s.end_with?("1") || @order.id.to_s.end_with?("4") || @order.id.to_s.end_with?("7"))
        sede = a2 end
      if (@order.id.to_s.end_with?("2") || @order.id.to_s.end_with?("5") || @order.id.to_s.end_with?("8"))
        sede = a3 end

      case @order.status
      when 1   #@actual_status = "Pickup complete"
        route = Route.first(:conditions => ["id =?", @order.route_id])
        @address1 = a0+" ,"+ route.created_at.to_s
        @address2 = sede+" ,"+ @order.collectiondate.to_s # traer solo la fecha del dia en que se busco el paquete
      when 2   #@actual_status = "Assigned for pickup"
        route = Route.first(:conditions => ["id =?", @order.route_id])
        @address1 = a0+" ,"+ route.created_at.to_s
      when 3   #@actual_status = "Delivered"
        route = Route.first(:conditions => ["id =?", @order.route_id])
        @address1 = a0+" ,"+ route.created_at.to_s
        @address2 = sede+" ,"+ @order.collectiondate.to_s
        @a=""
        if @order.company_id!=nil
          u=Postit.new
          @a=u.solicitar_track_id2(@order.external, @order.company_id)
        end
        @address3 = @a+"Delivered, " + @order.fulladdress + " ,"+ @order.deliverydate.to_s
      end

      @error = false
      respond_to do |format|
        format.xml { render :status => 200 }
      end

    else

      if params[:id] == nil
        @mensaje = "ID param is missing!"
      else
        @mensaje = "Order "+ params[:id] + " not found!"
      end

      @error = true
      respond_to do |format|
        format.xml{ render :status => 500 }
      end
    end
  end


  def support_request  # revisar si el cliente ya existe para no crearlo de nuevo y verificar los datos.
    
    @error = true
    if re = request_exception
      re_name = re.name.to_s
      if re_name == "REXML::ParseException"
        xml = nil
      else
        xml = params[:support_request]
        puts "toy aki1"+xml.to_s
      end
    end
    if xml != nil    ############### desde aqui
      puts "toy aki2 "+xml.to_s
      @client = Client.find(:first, :conditions => [" account = ?", xml["client"] ])

      if @client and @client.active == 1 # si consigue al cliente(compania) y esta activo
        @address = Address.find(:first, :conditions => [" nickname = ?", xml["address"]])
        @creditcard = Creditcard.find(:first, :conditions => [" number = ?", xml["creditcard"]])

        if @address and @creditcard and @address.client_id == @client.id and @creditcard.client_id == @client.id# si se econtro la tarjeta y la direccion

          Order.transaction do # Order.transaction
            @order = Order.new(xml["order"])
            @order.client_id = @client.id
            @order.address_id = @address.id
            @order.creditcard_id = @creditcard.id
            @order.status = 0
            @order.latitude = 0
            @order.longitude = 0
            if @order.save
              @package = Package.new(xml["package"])
              @package.order_id = @order.id
              @package.price = @package.weight * 5
              if @package.save
                @package.price = @package.weight * 5
                @package.save
                                            
                @ourtotal = @package.price + ( @package.price * 0.1 )
                @error = false
              end
            end
            if @error == true
              puts "falle"
              raise ActiveRecord::Rollback
            end

          end # Order.transaction
        end # si se econtro la tarjeta y la direccion

      end   # si consigue al cliente(compania) y esta activo

    end             ############# hasta aqui es la logica del web service para recibir

    respond_to do |format|
      if @error == true
        format.xml {render :status => 500}
      else
        format.xml {render :status => :created}
      end
    end
    
  end


  def format

    if re = request_exception 
      r = re.name.to_s
      if r == "REXML::ParseException"
        #puts "fue un error de tipo " + r
      end    
    end
    respond_to do |format|
      format.xml{ render :status => 200 }
    end
   
  end

end
