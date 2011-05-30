class WebServiceController < ApplicationController

    require 'uri'
    require 'net/https'
    require 'open-uri'

  def show


    respond_to do |format|
      format.xml #show.xml.builder
    end
  end


    def prueba #solicita

    #    begin
    #      xml_result_set = Net::HTTP.get_response(URI.parse("http://192.168.1.100:3000/personas.xml"))
    #    rescue Exception => e
    #      puts 'Connection error: ' + e.message
    #    end

    data = open("http://localhost:3001/recursos/show/5.xml").read

    #@a = xml_result_set.body

    @a = data
    respond_to do |format|
      format.html
    end
  end


  def pruebapost #manda


    data = "<recurso><name>prueba nombressss</nombre></persona>"
    #data variable donde va el xml

    uri = URI.parse("http://192.168.1.100:3001/recursos.xml")
    http = Net::HTTP.new(uri.host, uri.port)
    headers = { 'Content-Type'=>'application/xml', 'Content-Length'=>data.size.to_s }
    post = Net::HTTP::Post.new(uri.path, headers)
    response = http.request post, data

      case response
      when Net::HTTPCreated; @a = "Created"
      when Net::HTTPSuccess; @a = "succes"
      else response.error!   @a = "error"
      end

    render "show"
  end

  def track_id

    @order = Order.first(:conditions => ["id =?", params[:id]])
    if @order
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
        @address1 = a0+" ,"+ route.created_at
        @address2 = sede+" ,"+ @order.collectiondate.date # traer solo la fecha del dia en que se busco el paquete
      when 2   #@actual_status = "Assigned for pickup"
        route = Route.first(:conditions => ["id =?", @order.route_id])
        @address1 = a0+" ,"+ route.created_at
      when 3   #@actual_status = "Delivered"
        route = Route.first(:conditions => ["id =?", @order.route_id])
        @address1 = a0+" ,"+ route.created_at
        @address2 = sede+" ,"+ @order.collectiondate.date
        @address3 = "Delivered, " + @order.fulladdress + " ,"+ @order.deliverydate
      end

      respond_to do |format|
        format.xml 
      end

    else
      flash[:error] = "Order not found"
      redirect_to :controller => 'home', :action => 'index'
    end
  end



end
