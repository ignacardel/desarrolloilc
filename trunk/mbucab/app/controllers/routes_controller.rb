class RoutesController < ApplicationController
  before_filter :require_dispatcher,:except => :my_route
  before_filter :require_carrier,:only => :my_route
  layout 'operationsmapmarker'
  # GET /routes
  # GET /routes.xml
  def index
    @routes = Route.find_by_sql("SELECT r.id, r.created_at,e.name,e.lastname from routes r, employees e where r.employee_id = e.id")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @routes }
    end
  end

  # GET /routes/1
  # GET /routes/1.xml
  def show
    @route = Route.find(params[:id])
    @addresses = Address.find_by_sql("select addresses.latitude, addresses.longitude, orders.id,orders.created_at,orders.status,clients.firstname, clients.lastname from orders, addresses, clients where orders.route_id="+@route.id.to_s+" and orders.address_id=addresses.id and orders.client_id = clients.id")
    @employee = Employee.find_by_sql("select employees.* from routes, employees where routes.employee_id=employees.id and routes.id="+@route.id.to_s)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @route }
    end
  end

  def my_route
    @route=Route.last(:conditions => ["employee_id = ?", session[:employeeid]])
    if (@route)
      @addresses = Address.find_by_sql("select addresses.latitude, addresses.longitude, orders.id,orders.created_at,orders.status,clients.firstname, clients.lastname from orders, addresses, clients where orders.route_id="+@route.id.to_s+" and orders.address_id=addresses.id and orders.client_id = clients.id")
      @employee = Employee.find_by_sql("select employees.* from employees where employees.id="+session[:employeeid].to_s)
      respond_to do |format|
        format.html # my_route.html.erb
        format.xml  { render :xml => @route }
      end
    else
      flash[:error] = "You have no assigned routes at the moment"
      redirect_to :controller => 'operations', :action => 'index'
    end
  end

  # GET /routes/new
  # GET /routes/new.xml
  def new
    @route = Route.new
    @addresses = Address.find_by_sql("select addresses.latitude,addresses.longitude,orders.id,orders.created_at,clients.firstname,clients.lastname from addresses, orders, clients where orders.address_id=addresses.id and orders.status=0 and orders.client_id = clients.id limit 10")
    @employees = Employee.find_by_sql("select * from employees e where (e.role=2 or e.role=1) and e.id not in (select r.employee_id from routes r,orders o where r.employee_id=e.id and o.status=2 and o.route_id=r.id)").map { |x| x.account }
    if @employees.size>0
      if @addresses.size>0
        respond_to do |format|
          format.html # new.html.erb
          format.xml  { render :xml => @route }
        end
      else
        flash[:error] = "There are no orders waiting for pickup"
        redirect_to :controller => 'routes', :action => 'index'
      end
    else
      flash[:error] = "There are no carriers available"
      redirect_to :controller => 'routes', :action => 'index'
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
    @employee=Employee.first(:conditions => ["account = ?", params[:employee_account]])
    if @employee
      @route.employee_id=@employee.id
    end
    respond_to do |format|
      if @route.save
        Order.update_all(["route_id=?",@route.id],:id=>params[:order_id])
        Order.update_all(["status=?",2],:id=>params[:order_id])
        flash[:notice] = 'Route was successfully created.'
        format.html { redirect_to(@route) }
        format.xml  { render :xml => @route, :status => :created, :location => @route }
      else
        @addresses = Address.find_by_sql("select addresses.latitude,addresses.longitude,orders.id,orders.created_at,clients.firstname,clients.lastname from addresses, orders, clients where orders.address_id=addresses.id and orders.status=0 and orders.client_id = clients.id limit 10")
        @employees = Employee.find_by_sql("select * from employees e where (e.role=2 or e.role=1) and e.id not in (select r.employee_id from routes r,orders o where r.employee_id=e.id and o.status=2 and o.route_id=r.id)").map { |x| x.account }

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
