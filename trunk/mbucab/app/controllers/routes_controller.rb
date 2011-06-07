class RoutesController < ApplicationController
  layout 'operationsmapmarker'
  # GET /routes
  # GET /routes.xml
  def index
    @routes = Route.find_by_sql("SELECT * from routes r, employees e on r.employee_id = e.id ")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @routes }
    end
  end

  # GET /routes/1
  # GET /routes/1.xml
  def show
    @route = Route.find(params[:id])
    @addresses = Address.find_by_sql("select addresses.latitude, addresses.longitude, orders.id,orders.created_at, clients.firstname, clients.lastname from routes, orders, addresses, clients where orders.route_id="+@route.id.to_s+" and orders.address_id=addresses.id and orders.client_id = clients.id limit 10")
    @employee = Employee.find_by_sql("select employees.* from routes, employees where routes.employee_id=employees.id limit 1")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @route }
    end
  end

  # GET /routes/new
  # GET /routes/new.xml
  def new
    @route = Route.new
    @addresses = Address.find_by_sql("select addresses.latitude,addresses.longitude,orders.id,orders.created_at,clients.firstname,clients.lastname from addresses, orders, clients where orders.address_id=addresses.id and orders.status=0 and orders.client_id = clients.id limit 10")
    @employees = Employee.find_by_sql("select * from employees")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @route }
    end
  end

  # GET /routes/1/edit
  def edit
    @route = Route.find(params[:id])
  end

  # POST /routes
  # POST /routes.xml
  def create
    @route = Route.new(params[:route])
    respond_to do |format|
      if @route.save
        Order.update_all(["route_id=?",@route.id],:id=>params[:order_id])
        Order.update_all(["status=?",2],:id=>params[:order_id])
        flash[:notice] = 'Route was successfully created.'
        format.html { redirect_to(@route) }
        format.xml  { render :xml => @route, :status => :created, :location => @route }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @route.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /routes/1
  # PUT /routes/1.xml
  def update
    @route = Route.find(params[:id])

    respond_to do |format|
      if @route.update_attributes(params[:route])
        flash[:notice] = 'Route was successfully updated.'
        format.html { redirect_to(@route) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @route.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /routes/1
  # DELETE /routes/1.xml
  def destroy
    @route = Route.find(params[:id])
    @route.destroy

    respond_to do |format|
      format.html { redirect_to(routes_url) }
      format.xml  { head :ok }
    end
  end
end