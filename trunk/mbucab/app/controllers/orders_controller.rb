# Author:: Ignacio Cardenas, Leonardo Fraile, Ramses Velasquez
#
#Clase que contiene todos los metodos para las operaciones con
#ordenes de servicio. Ej: Crear, Modificar, Eliminar, Mostrar.
class OrdersController < ApplicationController
  before_filter :require_login,:except => [:show]
  layout 'standardmapmarker'
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

    @qr = "http://chart.apis.google.com/chart?chs=220x220&cht=qr&chl=http://"+local_ip+"/orders/" + @order.id.to_s

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
    @order = Order.new
    session[:order_params] = nil
    session[:order_params] ||= {}
    session[:order_step]   = nil

    client = Client.first(:conditions => [" account = ? ", session[:user]])
    @addresses = Address.all(:conditions =>["client_id = ?", client.id])
    1.times {@order.packages.build}

   
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
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
    session[:order_params].deep_merge!(params[:order]) if params[:order]
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]

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
        @addresses = Address.all(:conditions =>["client_id = ?", client.id])
        #1.times {@order.packages.build}
      end
      if @order.current_step == "payment"
        @order.packages.each do |package|
          #poner aqui la regla para el precio y iva y cambiarlo a una funcion aparte para no sobrecargar aqui
          actual = package.weight * 5
          @total = @total + actual
          package.price = actual
        end
        @creditcards = Creditcard.all(:conditions =>["client_id = ? AND expdate > ?", session[:id], Date.current])

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

end
