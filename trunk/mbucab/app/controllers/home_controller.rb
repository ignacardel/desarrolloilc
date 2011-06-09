# Author:: Ignacio Cardenas, Leonardo Fraile, Ramses Velasquez
#
#Clase que contiene el metodo para renderizar la vista del home

class HomeController < ApplicationController
  skip_before_filter :require_login
  layout 'standardmapmarker'

  #Renderiza la vista del home
  def index

    @orders =  Order.all(:conditions =>["client_id = ? AND order_type = ?", session[:id],1])
    if @orders 
     @number =  @orders.size
    end

  end

end
