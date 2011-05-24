class OperationsController < ApplicationController
  layout 'operationsmapmarker'
  skip_before_filter :require_employee_login

  def index
  end

end
