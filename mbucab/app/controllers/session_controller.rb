class SessionController < ApplicationController
  skip_before_filter :require_login

  def client_login

    request.query_string.split(/&/).inject({}) do |hash, setting|
      key, val = setting.split(/=/)
      if key == 'openid.ext1.value.email'
        usuario, correo  = val.split(/%40/)
        @email = usuario + '@' + correo
      end
    end

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
        flash[:notice] = "\"" + @email + "\" is not in registered!"
        redirect_to :controller => 'home', :action => 'index'
    end
    
  end

    def client_logout
      session[:user] = nil
      session[:type] = nil
      session[:id] = nil
      flash[:notice] = 'You have successfully logged out'
      redirect_to :controller => 'home', :action => 'index'

    end

    def client_deactivate
      session[:user] = nil
      session[:type] = nil
      session[:id] = nil
      flash[:notice] = 'Your account has been deactivated. <br /> To reactivate your account, log in using your old login email and password.'
      redirect_to :controller => 'home', :action => 'index'

    end
end
