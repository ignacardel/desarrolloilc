# Author:: Ignacio Cardenas, Leonardo Fraile, Ramses Velasquez
#
#Clase que contiene todos los metodos para las operaciones con
#empleados. Aun no se ha empleado.
class EmployeesController < ApplicationController
  before_filter :require_admin,:except => [:show,:edit]
  layout 'operationsmapmarker'
  # GET /employees
  # GET /employees.xml
  def index
    @employees = Employee.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employees }
    end
  end

  # GET /employees/1
  # GET /employees/1.xml
  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.xml
  def new
    @employee = Employee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
    @employee.password=""
  end

  # POST /employees
  # POST /employees.xml
  def create
    @employee = Employee.new(params[:employee])
    @employee.password=Digest::SHA1.hexdigest(@employee.password) if !(@employee.password.blank?)
    respond_to do |format|
      if @employee.save
        flash[:notice] = 'Employee was successfully created.'
        format.html { redirect_to(@employee) }
        format.xml  { render :xml => @employee, :status => :created, :location => @employee }
      else
        @employee.password=""
        format.html { render :action => "new" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.xml
  def update
    @employee = Employee.find(params[:id])
    params[:employee].delete(:password) if params[:employee][:password].blank?
    params[:employee][:password]=Digest::SHA1.hexdigest(params[:employee][:password]) if !(params[:employee][:password].blank?)
    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        flash[:notice] = 'Employee was successfully updated.'
        format.html { redirect_to(@employee) }
        format.xml  { head :ok }
      else
        @employee.password=""
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.xml
  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to(employees_url) }
      format.xml  { head :ok }
    end
  end
end
