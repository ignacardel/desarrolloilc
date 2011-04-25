class OrdersController < ApplicationController
  layout 'standardmapmarker'
  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])
    @address    = Address.first(:conditions =>["id = ?", @order.address_id])
    @creditcard = Creditcard.first(:conditions =>["id = ?", @order.creditcard_id])
    client      = Client.first(:conditions => [" id = ? ", @order.client_id])
    @name       = client.firstname + " " + client.lastname
    #aqui se pone el ip y el metodo para hacer lo del codigo qr
    @qr = "http://"+request.host_with_port+"/orders/" + @order.id.to_s

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
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
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    session[:order_params].deep_merge!(params[:order]) if params[:order]
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]

     if @order.current_step == "confirmation"
       @order.client_id = session[:id]
       @order.status    = 0
       @order.packages.each do |package|
               #poner aqui la regla para el precio y iva y cambiarlo a una funcion aparte para no sobrecargar aqui
               actual = package.weight * 2
               package.price = actual
       end
       @order.save
       session[:order_step] = nil
       session[:order_params] = nil
     else
       @order.next_step
       session[:order_step] = @order.current_step
       @total = 0
       if @order.current_step == "payment"
             @order.packages.each do |package|
               #poner aqui la regla para el precio y iva y cambiarlo a una funcion aparte para no sobrecargar aqui
               actual = package.weight * 2
               @total = @total + actual
               package.price = actual
             end
             @creditcards = Creditcard.all(:conditions =>["client_id = ?", session[:id]])
       end
       if @order.current_step == "confirmation"
             @address    = Address.first(:conditions =>["id = ?", @order.address_id])
             @creditcard = Creditcard.first(:conditions =>["id = ?", @order.creditcard_id])
             client      = Client.first(:conditions => [" account = ? ", session[:user]])
             @name       = client.firstname + " " + client.lastname
             @order.packages.each do |package|
               #poner aqui la regla para el precio y iva y cambiarlo a una funcion aparte para no sobrecargar aqui
               actual = package.weight * 2
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
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
