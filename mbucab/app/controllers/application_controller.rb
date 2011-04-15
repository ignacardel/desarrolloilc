# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

     def gotogoogle

    redirect_to "https://www.google.com/accounts/o8/ud
?openid.ns=http://specs.openid.net/auth/2.0
&openid.ns.pape=http://specs.openid.net/extensions/pape/1.0
&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select
&openid.identity=http://specs.openid.net/auth/2.0/identifier_select
&openid.return_to=http://localhost:3000/clients/new
&openid.realm=http://localhost:3000/
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
  # hola esto es una prueba
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
