# Author:: Ignacio Cardenas, Leonardo Fraile, Ramses Velasquez
#
#Clase que contiene todos los metodos para las operaciones
#de sesion de usuario o empleados

class SessionController < ApplicationController
  skip_before_filter :require_login

  #Metodo que recibe los parametros devueltos por el API de Google OpenID
  #para validar que el usuario exista cuando intenta hacer login.
  #Si existe, inicia sesion y se le concede acceso a todas las funcionalidades
  #de usuario.
  def client_login

    request.query_string.split(/&/).inject({}) do |hash, setting|
      key, val = setting.split(/=/)
      if key == 'openid.mode'
        @cancel = val
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
        logger.info '****MAIL BOXES UCAB CUSTOM LOG ENTRY**** Customer '+client.account+' has succesfully logged in! at '+Time.now.to_s
        if client.active == 0
          client.active = 1;
          client.update_attributes(params[:client])
          session[:user] = client.account
          session[:id]= client.id
          session[:type] = "client"
          flash[:notice] = t('home.flash.reactivated1') + client.firstname + " " + client.lastname + " (" + session[:user] + t('home.flash.reactivated2')
          redirect_to :controller => 'home', :action => 'index'
        else
          session[:user] = client.account
          session[:id]= client.id
          session[:type] = "client"
          flash[:notice] = client.firstname + " " + client.lastname + " (" + session[:user] + t('home.flash.login')
          redirect_to :controller => 'home', :action => 'index'
        end
      else
        flash[:error] = @email + t('notregistered')
        logger.info '****MAIL BOXES UCAB CUSTOM LOG ENTRY**** Failed customer login attempt from '+@email+' at '+Time.now.to_s
        redirect_to :controller => 'home', :action => 'index'
      end
    end

  end

  #Metodo que finaliza la sesion del usuario cuando este hace logout
  def client_logout
    #    if session[:user]!=nil
    logger.info '****MAIL BOXES UCAB CUSTOM LOG ENTRY**** Customer '+session[:user]+' has succesfully logged out! at '+Time.now.to_s
    session[:user] = nil
    session[:type] = nil
    session[:id] = nil
    flash[:notice] = t('home.flash.loggedout')
    redirect_to :controller => 'home', :action => 'index'
    #    else
    #    end
  end

  #Metodo que finaliza la sesion del usuario cuando este desactiva su cuenta
  def client_deactivate
    logger.info '****MAIL BOXES UCAB CUSTOM LOG ENTRY**** Customer '+session[:user]+' has successfully deactivated his/her account! at '+Time.now.to_s
    session[:user] = nil
    session[:type] = nil
    session[:id] = nil
    flash[:notice] = t('home.flash.deactivated')
    redirect_to :controller => 'home', :action => 'index'
  end

  #Metodo que recibe los parametros devueltos por el login box de
  #la pagina principal de operaciones para validar que el usuario exista cuando
  #intenta hacer login. Si existe, inicia sesion y se le concede acceso a
  #las funcionalidades que le corresponden a su rol
  def employee_login

    @hash=Digest::SHA1.hexdigest(params[:password])
    puts(@hash)
    employee= Employee.find(:first, :conditions => [" account = ? AND password = ?", params[:account],@hash])

    if employee

      session[:employee] = employee.account
      session[:employeeid]= employee.id
      session[:role]=employee.role
      flash[:notice] = employee.name + " " + employee.lastname + " (" + session[:employee] + t('operations.flash.login')
      redirect_to :controller => 'operations', :action => 'index'
      logger.info '****MAIL BOXES UCAB CUSTOM LOG ENTRY**** Employee '+employee.account+' has succesfully logged in! at '+Time.now.to_s
    else
      flash[:error] = t('operations.flash.loginfail')
      logger.info '****MAIL BOXES UCAB CUSTOM LOG ENTRY**** Failed employee login attempt from '+params[:account]+' at '+Time.now.to_s
      redirect_to :controller => 'operations', :action => 'index'
    end

  end

  #Metodo que finaliza la sesion del empleado cuando este hace logout
  def employee_logout
    logger.info '****MAIL BOXES UCAB CUSTOM LOG ENTRY**** Employee '+session[:employee]+' has succesfully logged out! at '+Time.now.to_s
    session[:employee] = nil
    session[:employeeid] = nil
    session[:role] = nil
    flash[:notice] = t('operations.flash.loggedout')
    redirect_to :controller => 'operations', :action => 'index'
  end
end
