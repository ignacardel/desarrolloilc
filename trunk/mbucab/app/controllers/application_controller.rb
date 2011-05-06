# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  require 'socket'
  
  def gotogoogle

    redirect_to "https://www.google.com/accounts/o8/ud
?openid.ns=http://specs.openid.net/auth/2.0
&openid.ns.pape=http://specs.openid.net/extensions/pape/1.0
&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select
&openid.identity=http://specs.openid.net/auth/2.0/identifier_select
&openid.return_to=http://"+request.host_with_port+"/clients/new
&openid.realm=http://"+request.host_with_port+"/
&openid.assoc_handle=ABSmpf6DNMw
&openid.mode=checkid_setup
&openid.ui.ns=http://specs.openid.net/extensions/ui/1.0
&openid.ui.mode=popup
&openid.ui.icon=true
&openid.ns.ax=http://openid.net/srv/ax/1.0
&openid.ax.mode=fetch_request
&openid.ax.type.email=http://axschema.org/contact/email
&openid.ax.type.language=http://axschema.org/pref/language
&openid.ax.type.firstname=http://axschema.org/namePerson/first
&openid.ax.type.lastname=http://axschema.org/namePerson/last
&openid.ax.required=email,language,firstname,lastname"

  end

  def clientgotogoogle

    redirect_to "https://www.google.com/accounts/o8/ud
?openid.ns=http://specs.openid.net/auth/2.0
&openid.ns.pape=http://specs.openid.net/extensions/pape/1.0
&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select
&openid.identity=http://specs.openid.net/auth/2.0/identifier_select
&openid.return_to=http://"+request.host_with_port+"/session/client_login
&openid.realm=http://"+request.host_with_port+"/
&openid.assoc_handle=ABSmpf6DNMw
&openid.mode=checkid_setup
&openid.ui.ns=http://specs.openid.net/extensions/ui/1.0
&openid.ui.mode=popup
&openid.ui.icon=true
&openid.ns.ax=http://openid.net/srv/ax/1.0
&openid.ax.mode=fetch_request
&openid.ax.type.email=http://axschema.org/contact/email
&openid.ax.type.language=http://axschema.org/pref/language
&openid.ax.type.firstname=http://axschema.org/namePerson/first
&openid.ax.type.lastname=http://axschema.org/namePerson/last
&openid.ax.required=email,language,firstname,lastname"

  end

  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily
    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end

  private

  def require_login
    if(session[:user]==nil)
      redirect_to :controller => 'home', :action => 'index'
    end
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end