class SessionController < ApplicationController

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
     session[:user] = client.account
     flash[:notice] = client.firstname + " " + client.lastname + " (" + session[:user] + ") has logged in!"
     redirect_to :controller => 'home', :action => 'index'
    else
     flash[:notice] = "\"" + @email + "\" is not in registered!"
     redirect_to :controller => 'home', :action => 'index'
    end

  end

  def client_logout
    session[:user] = nil
    flash[:notice] = 'Logged out'
    redirect_to :controller => 'home', :action => 'index'

  end

end
