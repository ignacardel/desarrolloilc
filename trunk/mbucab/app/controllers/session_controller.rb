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
        if client.active == 0
          client.active = 1;
          client.update_attributes(params[:client])
          session[:user] = client.account
          session[:id]= client.id
          session[:type] = "client"
          flash[:notice] = 'Your account has been reactivated. Welcome back! <br />' + client.firstname + " " + client.lastname + " (" + session[:user] + ") has logged in!"
          redirect_to :controller => 'home', :action => 'index'
        else
          session[:user] = client.account
          session[:id]= client.id
          session[:type] = "client"
          flash[:notice] = client.firstname + " " + client.lastname + " (" + session[:user] + ") has logged in!"
          redirect_to :controller => 'home', :action => 'index'
        end
      else
        flash[:error] = "\"" + @email + "\" is not in registered!"
        redirect_to :controller => 'home', :action => 'index'
      end
    end
    
  end

  #Metodo que finaliza la sesion del usuario cuando este hace logout
  def client_logout
    #    if session[:user]!=nil
    session[:user] = nil
    session[:type] = nil
    session[:id] = nil
    flash[:notice] = 'You have successfully logged out'
    redirect_to :controller => 'home', :action => 'index'
    #    else
    #    end
  end

  #Metodo que finaliza la sesion del usuario cuando este desactiva su cuenta
  def client_deactivate
    session[:user] = nil
    session[:type] = nil
    session[:id] = nil
    flash[:notice] = 'Your account has been deactivated. <br /> To reactivate your account, log in using your Gmail account.'
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
      flash[:notice] = employee.name + " " + employee.lastname + " (" + session[:employee] + ") has logged in!"
      redirect_to :controller => 'operations', :action => 'index'
     
    else
      flash[:error] = "Login failed"
      redirect_to :controller => 'operations', :action => 'index'
    end

  end

  #Metodo que finaliza la sesion del empleado cuando este hace logout
  def employee_logout
    session[:employee] = nil
    session[:employeeid] = nil
    session[:role] = nil
    flash[:notice] = 'You have successfully logged out'
    redirect_to :controller => 'operations', :action => 'index'
  end
end
