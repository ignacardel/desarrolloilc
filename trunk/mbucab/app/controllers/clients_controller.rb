# Author:: Ignacio Cardenas, Leonardo Fraile, Ramses Velasquez
#
#Clase que contiene todos los metodos para las operaciones con
#usuarios. Ej: Crear, Modificar, Eliminar, Mostrar.
class ClientsController < ApplicationController
  before_filter :require_login,:except => [:new,:create]
  layout 'standardmapmarker'
  # GET /clients
  # GET /clients.xml

  #Metodo que se encarga de mostrar todos los usuarios.
  #No se utiliza en mail boxes ucab
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
  # Renderiza la vista para mostrar toda la informacion del usuario que
  # inicio sesion
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
  # Renderiza el formulario para crear un nuevo usuario
  def new
   
    request.query_string.split(/&/).inject({}) do |hash, setting|
      key, val = setting.split(/=/)
      if key == 'openid.mode'
        @cancel = val
      end
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

    if @cancel=='cancel'
      redirect_to :controller => 'home', :action => 'index'
    else
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

  end

  # GET /clients/1/edit
  # Renderiza la vista para editar los datos del usuario que inicio sesion
  def edit
    if(session[:id].to_s!=params[:id].to_s)
      redirect_to :controller => 'home', :action => 'index'
    else
      @client = Client.find(params[:id])
    end
  end

  # POST /clients
  # POST /clients.xml
  # Metodo llamado despues de crear un usuario nuev0.
  # De no poder crearse da un mensaje de error
  #  y se redirige al formulario de creacion.
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
  # Metodo llamado despues de editar la informacion del usuario.
  # Si la modificacion fue exitosa, se recibe un mensaje de confirmacion,
  # de lo contrario, se recibe un error.
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        flash[:notice] = 'You have successfully updated your account settings!'
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
  # Metodo que se encarga de desactivar la cuenta de un usuario.
  def destroy
    @client = Client.find(params[:id])
    @client.active = 0;

    respond_to do |format|
      @client.update_attributes(params[:client])
      format.html { redirect_to(:controller => :session, :action => :client_deactivate) }
    end
  end

end