class JogsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :through => :user
    
  def index
    if(params.has_key?(:start_date) && params.has_key?(:end_date))
      filter = params[:start_date]..params[:end_date]
      @jogs = Jog.where(:user_id => params[:user_id]).where(:date => filter)
    else
      @jogs = Jog.where(:user_id => params[:user_id])
    end    
    
    json_response(@jogs)    
  end
  
  def create
     @jog = Jog.create!(jog_params)
     json_response(@jog, :created)
  end
  
  def show
    @jog = Jog.find(params[:id])
    json_response(@jog)
  end
  
  def update
    @jog = Jog.find(params[:id])
    @jog.update(jog_params)
    head :no_content
  end
  
  def destroy
    @jog = Jog.find(params[:id])
    @jog.destroy
    head :no_content
  end
    
  private
  
  def jog_params
    params.permit(:date, :time, :distance, :user_id)
  end
    
end
