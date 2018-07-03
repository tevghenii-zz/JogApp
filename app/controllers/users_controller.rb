class UsersController < ApplicationController
  
  def index
    @users = User.all
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
    @user.update(user_params)
    head :no_content
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    head :no_content
  end  
  
  private
  
  def user_params
    params.permit(:email, :name, :password_digest, :password,  :password_confirmation)
  end
  
  def update_user_params
    params.permit(:email, :name)
  end
  
end
