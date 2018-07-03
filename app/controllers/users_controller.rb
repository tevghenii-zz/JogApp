class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create, raise: false
  load_and_authorize_resource
  
  def index
    @users = User.all
    json_response(@users)
  end
  
  def users
    @users = User.where(:role => 'user')
    json_response(@users)
  end
  
  def create
     @user = User.create!(user_params)
     json_response(@user, :created)
  end
  
  def show
    @user = User.find(params[:id])
    json_response(@user)
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(update_user_params)
    head :no_content
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    head :no_content
  end
  
  def me
    json_response(@current_user)
  end
  
  def update_role
    @user = User.find(params[:id])
    @user.update(update_user_role_params)
    head :no_content    
  end
  
  private
  
  def user_params
    params.permit(:email, :name, :password_digest, :password,  :password_confirmation)
  end
  
  def update_user_params
    params.permit(:id, :name, :email)
  end
  
  def update_user_role_params
    params.permit(:id, :role)
  end  
  
end
