class ClientsController < ApplicationController
  layout 'standardmapmarker'
  # GET /clients
  # GET /clients.xml

  def index
    @clients = Client.find(:all, :conditions => [" id = ?", session[:id] ])
    #@clients = Client.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    if(session[:id].to_s!=params[:id].to_s)
      redirect_to :controller => 'home', :action => 'index'
    else
      @client = Client.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @client }
      end
    end
  end
  # GET /clients/new
  # GET /clients/new.xml
  def new
   
    request.query_string.split(/&/).inject({}) do |hash, setting|
      key, val = setting.split(/=/)
      if key == 'openid.ext1.value.firstname'
        @nombre = val
      end
      if key == 'openid.ext1.value.lastname'
        @apellido = val
      end
      if key == 'openid.ext1.value.email'
        usuario, correo  = val.split(/%40/)
        @email = usuario + '@' + correo
      end
    end

    client= Client.find(:first, :conditions => [" account = ?", @email ])
    
    if client     
      flash[:notice] = "\"" + @email + "\" is already registered!"
      redirect_to :controller => 'home', :action => 'index'
    else
      @client = Client.new
      @client.account   = @email
      @client.firstname = @nombre
      @client.lastname  = @apellido

      @client.addresses.build
      @client.creditcards.build
      
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @client }
      end
    end

  end

  # GET /clients/1/edit
  def edit
    if(session[:id].to_s!=params[:id].to_s)
      redirect_to :controller => 'home', :action => 'index'
    else
      @client = Client.find(params[:id])
    end
  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])
    @client.active=1
    respond_to do |format|
      if @client.save
        flash[:notice] = 'You have successfully registered!'
        format.html { redirect_to(@client) }
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.xml
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        flash[:notice] = 'You have successfully updated your info.'
        format.html { redirect_to(@client) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.xml
  def destroy
    @client = Client.find(params[:id])
    @client.active = 0;

    respond_to do |format|
      @client.update_attributes(params[:client])
      format.html { redirect_to(:controller => :session, :action => :client_deactivate) }
    end
  end

end