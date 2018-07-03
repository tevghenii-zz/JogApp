class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include CanCan::ControllerAdditions
  
  before_action :authenticate_request
  attr_reader :current_user
  
  private
  
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { message: 'Not Authorized', "status": 'error' }, status: 401 unless @current_user
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: 'Forbidden Access', "status": 'error' }, status: 403
  end  
  
end
