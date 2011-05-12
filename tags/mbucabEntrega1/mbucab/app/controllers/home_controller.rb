# Author:: Ignacio Cardenas, Leonardo Fraile, Ramses Velasquez
#
#Clase que contiene el metodo para renderizar la vista del home

class HomeController < ApplicationController
  skip_before_filter :require_login
  layout 'standardmapmarker'

  #Renderiza la vista del home
  def index
  end

end
