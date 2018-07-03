class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  
  def login
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: { "data" => { "auth_token": command.result }, "status": "ok" }, status: status
    else
      render json: { message: command.errors[:user_authentication].first, status: "error" }, status: :unauthorized
    end
  end
end
