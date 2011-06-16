# Author:: Ignacio Cardenas, Leonardo Fraile, Ramses Velasquez
#
#Clase que contiene los metodos que pueden ser llamados desde cualquier
#otro controlador. Ej.: Metodos de redireccion al API de Google OpenID,etc.
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  require 'socket'

  before_filter :set_locale
#  def set_locale
#    session[:locale] = params[:locale] if params[:locale]
#    I18n.locale = session[:locale]
#  end

  def set_locale
    logger.info "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = extract_locale_from_accept_language_header
    logger.info "* Locale set to '#{I18n.locale}'"
  end

  #Metodo que redirecciona al API de Google OpenID cuando se trata de
  #un usuario nuevo. Si la autenticacion con Google es exitosa, redirecciona
  #a un formulario de nuevo usuario.
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
  
  #Metodo que redirecciona al API de Google OpenID cuando se trata del
  #login de un usuario existente. Si la autenticacion con Google es exitosa,
  #redirecciona al home y le da acceso al usuario a las funcionalidades de
  #usuario
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
  
  #Metodo que devuelve el IP del servidor
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
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
  #Metodo que redirecciona al home en caso de que un usuario intente
  #ingresar una funcionalidad sin haber iniciado sesion
  def require_login
    if(session[:user]==nil)
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  def require_admin
    if(session[:role]!=1)
      flash[:error]="Unauthorized access"
      redirect_to :controller => 'operations', :action => 'index'
    end
  end
  def require_dispatcher
    if(session[:role]==2)
      flash[:error]="Unauthorized access"
      redirect_to :controller => 'operations', :action => 'index'
    end
  end

  def require_carrier
    if(session[:role]==3)
      flash[:error]="Unauthorized access"
      redirect_to :controller => 'operations', :action => 'index'
    end
  end
end
