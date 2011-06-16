# Author:: Ignacio Cardenas, Leonardo Fraile, Ramses Velasquez
#
#Clase que contiene todos los metodos para las operaciones con
#ordenes de servicio. Ej: Crear, Modificar, Eliminar, Mostrar.
class OrdersController < ApplicationController
  before_filter :require_login,:except => [:show,:pickup,:notify,:track,:simulate,:simulation,:index_support_request,:new_support_request]
  before_filter :require_admin,:only => [:simulate,:simulation,:index_support_request,:new_support_request]
  layout :choose_layout

  require 'xmlsimple'
  
  # GET /orders
  # GET /orders.xml
  #Metodo que se encarga de mostrar todas las ordenes
  def index
    @orders = Order.find(:all, :conditions => [" client_id = ?", session[:id] ])
    #@orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders
  # GET /orders.xml
  #Metodo que se encarga de mostrar todas las ordenes
  def index_support_request
    @orders = Order.find_by_sql("select orders.*,companies.name FROM  orders, companies where (orders.order_type=1 or orders.order_type=2 or orders.order_type=3) and orders.company_id = companies.id")
    respond_to do |format|
      format.html # index_support_request.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  # Renderiza el formulario para crear una nueva orden
  def new_support_request
    @orders = Order.find_by_sql("Select * from orders where status=0 and company_id is null")
    @companies = Company.find_by_sql("Select * from companies")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  # Renderiza la vista para mostrar toda la informacion de una orden de un usuario.
  # Tambien muestra la orden en formato .PDF
  def show
    @order = Order.find(params[:id])
    @address    = Address.first(:conditions =>["id = ?", @order.address_id])
    @creditcard = Creditcard.first(:conditions =>["id = ?", @order.creditcard_id])
    client      = Client.first(:conditions => [" id = ? ", @order.client_id])
    @name       = client.firstname + " " + client.lastname
    #aqui se pone el ip y el metodo para hacer lo del codigo qr

    @qr = "http://chart.apis.google.com/chart?chs=220x220&cht=qr&chl=http://"+local_ip+":3000/pickup/" + @order.id.to_s

    @total = 0
    @order.packages.each do |package|
      actual = package.weight * 5
      @total = @total + actual
    end
     
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
      format.pdf  { render :layout => false }
    end
  end
  
  # GET /orders/new
  # GET /orders/new.xml
  # Renderiza el formulario para crear una nueva orden
  def new
    @creditcards=Creditcard.find_by_sql("SELECT  * FROM CREDITCARDS WHERE STRFTIME('%Y-%m',expdate) >= strftime('%Y-%m',date('now')) and client_id="+session[:id].to_s)
    if @creditcards.size>0
      @order = Order.new
      session[:order_params] = nil
      session[:order_params] ||= {}
      session[:order_step]   = nil

      client = Client.first(:conditions => [" account = ? ", session[:user]])
      @addresses = Address.find_by_sql("select * from addresses where client_id='"+client.id.to_s+"'").map { |x| x.nickname}
      1.times {@order.packages.build}

   
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @order }
      end
    else
      flash[:error] = "All of your credit cards have expired"
      redirect_to :controller => 'orders', :action => 'index'
    end
  end

  # GET /orders/1/edit
  # Renderiza la vista para editar una orden. No se utiliza en mail boxes ucab.
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  # Metodo llamado despues de crear una orden nueva.
  # De no poder crearse la orden da un mensaje de error
  #  y se redirige al formulario de creacion.
  def create
    if session[:order_step] == "packages" and !params[:back_button]
      session[:order_params] = nil
      session[:order_params] ||= {}
    end
    if (session[:order_step]==nil || session[:order_step] == "packages")
      @address = Address.first(:conditions => ["nickname =? AND client_id=?" , params[:address_nickname],session[:id]])
      if @address
        params[:order][:address_id]=@address.id
      end
    end
    session[:order_params].deep_merge!(params[:order]) if params[:order]
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]

    
    #      @address = Address.first(:conditions => ["nickname =?", params[:address_nickname]])
    #      if @address
    #        params[:order][:address_id]=@address.id
    #      end

    if @order.current_step == "confirmation" and !params[:back_button]
      @order.client_id = session[:id]
      @order.status    = 0
      @order.packages.each do |package|
        #poner aqui la regla para el precio y iva y cambiarlo a una funcion aparte para no sobrecargar aqui
        actual = package.weight * 5
        package.price = actual
      end
      @order.save
      session[:order_step] = nil
      session[:order_params] = nil
    else

      if @order.valid?

        if params[:back_button]
          @order.back_step
        else
          @order.next_step
        end
      end
      session[:order_step] = @order.current_step
      @total = 0
      if @order.current_step == "packages"
        client = Client.first(:conditions => [" account = ? ", session[:user]])
        @addresses = Address.find_by_sql("select * from addresses where client_id='"+session[:id].to_s+"'").map { |x| x.nickname}
        #1.times {@order.packages.build}
      end
      if @order.current_step == "payment"
        @order.packages.each do |package|
          #poner aqui la regla para el precio y iva y cambiarlo a una funcion aparte para no sobrecargar aqui
          actual = package.weight * 5
          @total = @total + actual
          package.price = actual
        end
        @creditcards=Creditcard.find_by_sql("SELECT  * FROM CREDITCARDS WHERE STRFTIME('%Y-%m',expdate) >= strftime('%Y-%m',date('now')) and client_id="+session[:id].to_s)
      end
      if @order.current_step == "confirmation"
        @address    = Address.first(:conditions =>["id = ?", @order.address_id])
        @creditcard = Creditcard.first(:conditions =>["id = ?", @order.creditcard_id])
        client      = Client.first(:conditions => [" account = ? ", session[:user]])
        @name       = client.firstname + " " + client.lastname
        @order.packages.each do |package|
          #poner aqui la regla para el precio y iva y cambiarlo a una funcion aparte para no sobrecargar aqui
          actual = package.weight * 5
          @total = @total + actual
          package.price = actual
        end
      end
    end

    if @order.new_record?
      render "new"
    else
      redirect_to @order
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  # Metodo llamado despues de editar la informacion de una orden. No se utiliza
  # en mail boxes ucab
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        flash[:notice] = 'Order was successfully updated.'
        format.html { redirect_to(@order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  # Metodo que se encarga de eliminar una orden en especifico
  # No se utiliza en mail boxes ucab
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end

  def pickup
    @order = Order.find(params[:id])
    if @order.status==2
      @order.status=1
      @order.collectiondate=Time.now
      @order.save
    end
    respond_to do |format|
      format.xml
    end
  end

  def notify
    @order = Order.first(:conditions => [" id = ? ", params[:id]])
    if @order
      if @order.status==1
        flash[:notice] = "Order #"+@order.id.to_s+" has already been picked up"
      end
      if @order.status==0
        flash[:error] = "Order #"+@order.id.to_s+" has not been assigned for pickup yet"
      end
      if @order.status==4
        flash[:error] = "Order #"+@order.id.to_s+" has been assigned for external pickup"
      end
      if @order.status==2
        @order.status=1
        @order.collectiondate=Time.now
        @order.save
        flash[:notice] = "Order #"+@order.id.to_s+" has been picked up at "+@order.collectiondate.to_s
      end
     
    else
      flash[:error] = "Order not found"
    end
    redirect_to :controller => 'operations', :action => 'index'
  end


  def track
 

    @order = Order.first(:conditions => ["id =?", params[:trackid]])

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
        @address1 = a0+" ,"+ route.created_at.to_s
        @address2 = sede+" ,"+ @order.collectiondate.to_s
        #@order.collectiondate.year.to_s+"-"+@order.collectiondate.month.to_s+"-"+@order.collectiondate.day.to_s # traer solo la fecha del dia en que se busco el paquete
      when 2   #@actual_status = "Assigned for pickup"
        route = Route.first(:conditions => ["id =?", @order.route_id])
        @address1 = a0+" ,"+ route.created_at.to_s
      when 3   #@actual_status = "Delivered"
        route = Route.first(:conditions => ["id =?", @order.route_id])
        @address1 = a0+" ,"+ route.created_at.to_s
        @address2 = sede+" ,"+ @order.collectiondate.to_s
        @address3 = "Delivered, " + @order.fulladdress + " ,"+ @order.deliverydate.to_s
      end

      respond_to do |format|
        format.html # show.html.erb
      end

    else
      flash[:error] = "Order not found"
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  def notification
    @orders =  Order.all(:conditions =>["client_id = ? AND order_type = ? OR  order_type = ? OR  order_type = ?", session[:id],1,2,3])
  end

  def accept_charge

    @order = Order.find(params[:id])

    if params[:option] == "1"
      @order.update_attribute(:order_type, 2)
      flash[:notice] = "New price for Order #"+params[:id]+ " Accepted!"
    else
      @order.update_attribute(:order_type, 3)
      flash[:notice] = "New price for Order #"+params[:id]+ " Rejected"
    end
    @order.save


    redirect_to :controller => 'orders', :action => 'notification' ,:id =>1
  end

  def simulation
    @orders = Order.all(:conditions => [" status = ?", 1 ])
    if @orders.size>0
      respond_to do |format|
        format.html # simulation.html.erb
        format.xml  { render :xml => @orders }
      end
    else
      flash[:error] = "There are no orders available for simulation"
      redirect_to :controller => 'operations', :action => 'index'
    end
  end

  def simulate
    @order = Order.first(:conditions => [" id = ? ", params[:id]])
    if @order
      case @order.status
      when 1
        @order.update_attribute(:status, 3)
        @order.deliverydate=Time.now
        @order.save
        flash[:notice] = "Order #" + params[:id]+ " has been successfully delivered!"
      when 0
        flash[:notice] = "Order #" + params[:id]+ " has not been picked up!"
      when 2
        flash[:notice] = "Order #" + params[:id]+ " has not been picked up!"
      when 4
        flash[:notice] = "Order #" + params[:id]+ " has not been picked up!"
      when 3
        flash[:notice] = "Order #" + params[:id]+ " has already been delivered!"
      end
    else
      flash[:error] = "Order #" + params[:id]+ " not found!"
    end
    redirect_to :controller => 'operations', :action => 'index'
  end
  
  private

  def choose_layout
    case action_name
    when "simulation","index_support_request","new_support_request"
      "operationsmapmarker"
    else
      "standardmapmarker"
    end
  end
  
end
