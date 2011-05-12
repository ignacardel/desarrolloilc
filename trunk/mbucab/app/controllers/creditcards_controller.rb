# Author:: Ignacio Cardenas, Leonardo Fraile, Ramses Velasquez
#
#Clase que contiene todos los metodos para las operaciones con
#tarjetas de credito. Ej: Crear, Modificar, Eliminar, Mostrar.
class CreditcardsController < ApplicationController
  before_filter :require_login,:except => [:code]
  layout 'standard',:except => [:code]
  # GET /creditcards
  # GET /creditcards.xml
  #Metodo que se encarga de mostrar todas las tarjetas de credito
  def index
    @creditcards = Creditcard.find(:all, :conditions => [" client_id = ?", session[:id] ])
    #@creditcards=Creditcard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @creditcards }
    end
  end

  # GET /creditcards/1
  # GET /creditcards/1.xml
  # Renderiza la vista para mostrar toda la informacion de una tarjeta
  # de credito de un usuario
  def show
    creditcard = Creditcard.find(:first, :conditions => [" id = ?", params[:id] ])
    if(session[:id].to_s!= creditcard.client_id.to_s)
      redirect_to :controller => 'home', :action => 'index'
    else
      @creditcard = Creditcard.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @creditcard }
      end
    end
  end

  # GET /creditcards/new
  # GET /creditcards/new.xml
  # Renderiza el formulario para crear una nueva tarjeta de credito
  def new
    @creditcard = Creditcard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @creditcard }
    end
  end

  # GET /creditcards/1/edit
  # Renderiza la vista para editar una tarjeta de credito
  def edit
    creditcard = Creditcard.find(:first, :conditions => [" id = ?", params[:id] ])
    if(session[:id].to_s!= creditcard.client_id.to_s)
      redirect_to :controller => 'home', :action => 'index'
    else
      @creditcard = Creditcard.find(params[:id])
    end
  end

  # POST /creditcards
  # POST /creditcards.xml
  # Metodo llamado despues de crear una tarjeta de credito nueva.
  # De no poder crearse da un mensaje de error
  #  y se redirige al formulario de creacion.
  def create
    @creditcard = Creditcard.new(params[:creditcard])
    @creditcard.client_id=session[:id]
    respond_to do |format|
      if @creditcard.save
        flash[:notice] = 'Creditcard was successfully created.'
        format.html { redirect_to(@creditcard) }
        format.xml  { render :xml => @creditcard, :status => :created, :location => @creditcard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @creditcard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /creditcards/1
  # PUT /creditcards/1.xml
  # Metodo llamado despues de editar la informacion de una tarjeta de credito.
  # Si la modificacion fue exitosa, se recibe un mensaje de confirmacion,
  # de lo contrario, se recibe un error.
  def update
    @creditcard = Creditcard.find(params[:id])

    respond_to do |format|
      if @creditcard.update_attributes(params[:creditcard])
        flash[:notice] = 'Creditcard was successfully updated.'
        format.html { redirect_to(@creditcard) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @creditcard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /creditcards/1
  # DELETE /creditcards/1.xml
  # Metodo que se encarga de eliminar una tarjeta de credito en especifico
  # No se utiliza en mail boxes ucab
  def destroy
    @creditcard = Creditcard.find(params[:id])
    @creditcard.destroy

    respond_to do |format|
      format.html { redirect_to(creditcards_url) }
      format.xml  { head :ok }
    end
  end

  def code
    render :template => 'creditcards/code'
  end
end
