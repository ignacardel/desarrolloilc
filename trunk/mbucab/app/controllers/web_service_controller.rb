class WebServiceController < ApplicationController

    require 'uri'
    require 'net/https'
    require 'open-uri'


    skip_before_filter :check_request_exception # filter the plugin installed

  

  def perra #manda POST
    ord_id = params[:order_support_request_id]
    comp = params[:company_support_request_id]
    u = Ucab.new
    @a = u.solicitar_servicio(ord_id, comp)

    render "show"
  end


  def track_id


#    @error = true
#    if re = request_exception
#      re_name = re.name.to_s
#      if re_name == "REXML::ParseException"
#        xml = nil
#      else
#        xml = params[:support_request]
#      end
#    end



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
        @address2 = sede+" ,"+ @order.collectiondate.date.to_s # traer solo la fecha del dia en que se busco el paquete
      when 2   #@actual_status = "Assigned for pickup"
        route = Route.first(:conditions => ["id =?", @order.route_id])
        @address1 = a0+" ,"+ route.created_at.to_s
      when 3   #@actual_status = "Delivered"
        route = Route.first(:conditions => ["id =?", @order.route_id])
        @address1 = a0+" ,"+ route.created_at.to_s
        @address2 = sede+" ,"+ @order.collectiondate.date.to_s
        @address3 = "Delivered, " + @order.fulladdress + " ,"+ @order.deliverydate.to_s
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
      end
    end
      if xml != nil
        @client = Client.new(xml["client"])
        @client.active=1
        Order.transaction do
          if @client.save
              @creditcard = Creditcard.new(xml["creditcard"])
              @creditcard.client_id=@client.id
              if @creditcard.save
                  @address = Address.new(xml["address"])
                  @address.client_id=@client.id
                  if @address.save
                      @order = Order.new(xml["order"])
                      @order.client_id = @client.id
                      @order.address_id = @address.id
                      @order.creditcard_id = @creditcard.id
                      @order.status = 0
                      if @order.save
                          @package = Package.new(xml["package"])
                          @package.order_id = @order.id
                          @package.price = @package.weight * 5
                          if @package.save
                              @package.price = @package.weight * 5
                              @package.save
                              if xml["total"] != nil and xml["total"].to_f > 0
                                @t = xml["total"]
                                @ourtotal = @package.price + ( @package.price * 0.1 )
                                @total = @t.to_f + @ourtotal
                                @error = false
                              end
                          end
                      end
                  end
              end
          end
          if @error == true
             raise ActiveRecord::Rollback
          end
        end

     end

     respond_to do |format|
       if @error == true
         format.xml {render :status => 500}
       else
         format.xml {render :status => :created}
       end
     end
    
  end


  def support_request_format

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
