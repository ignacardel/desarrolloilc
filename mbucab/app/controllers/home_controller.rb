class HomeController < ApplicationController
  skip_before_filter :require_login
  layout 'standard'
  def index
  end

end
