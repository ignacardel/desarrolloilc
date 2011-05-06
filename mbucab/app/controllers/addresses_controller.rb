class AddressesController < ApplicationController
  before_filter :require_login
  layout 'standardmapmarker'
  # GET /addresses
  # GET /addresses.xml
  def index
    @addresses = Address.find(:all, :conditions => [" client_id = ?", session[:id] ])
    #@addresses = Address.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @addresses }
    end
  end
  
  # GET /addresses/1
  # GET /addresses/1.xml
  def show
    adress = Address.find(:first, :conditions => [" id = ?", params[:id] ])
    if(session[:id].to_s!= adress.client_id.to_s)
      redirect_to :controller => 'home', :action => 'index'
    else
      @address = Address.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @address }
      end
    end
  end

  # GET /addresses/new
  # GET /addresses/new.xml
  def new
    @address = Address.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @address }
    end
  end

  # GET /addresses/1/edit
  def edit
    adress = Address.find(:first, :conditions => [" id = ?", params[:id] ])
    if(session[:id].to_s!= adress.client_id.to_s)
      redirect_to :controller => 'home', :action => 'index'
    else
      @address = Address.find(params[:id])
    end
  end

  # POST /addresses
  # POST /addresses.xml
  def create
    @address = Address.new(params[:address])
    @address.client_id=session[:id]
    respond_to do |format|
      if @address.save
        flash[:notice] = 'Address was successfully created.'
        format.html { redirect_to(@address) }
        format.xml  { render :xml => @address, :status => :created, :location => @address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /addresses/1
  # PUT /addresses/1.xml
  def update
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = 'Address was successfully updated.'
        format.html { redirect_to(@address) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.xml
  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    respond_to do |format|
      format.html { redirect_to(addresses_url) }
      format.xml  { head :ok }
    end
  end
end
