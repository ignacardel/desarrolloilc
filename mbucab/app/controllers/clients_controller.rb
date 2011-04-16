class ClientsController < ApplicationController
  layout 'standard'
  # GET /clients
  # GET /clients.xml

  #metodo abstracto para comprobar login
  def self.authenticate(email)

    usu= Client.find(params[:account])
    return nil if usu.nil?
    return usu if email == usu.email
    nil
  end


  def index
    @clients = Client.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.xml
  def new
    @client = Client.new


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

    @client.account   = @email
    @client.firstname = @nombre
    @client.lastname  = @apellido

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])

    respond_to do |format|
      if @client.save
        flash[:notice] = 'Client was successfully created.'
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
        flash[:notice] = 'Client was successfully updated.'
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
    @client.destroy

    respond_to do |format|
      format.html { redirect_to(clients_url) }
      format.xml  { head :ok }
    end
  end
end
