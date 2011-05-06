class CreditcardsController < ApplicationController
  before_filter :require_login
  layout 'standard',:except => [:code]
  # GET /creditcards
  # GET /creditcards.xml
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
  def new
    @creditcard = Creditcard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @creditcard }
    end
  end

  # GET /creditcards/1/edit
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
