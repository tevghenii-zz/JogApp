require "spec_helper"  
require 'jwt'

describe "JoggingTracker REST API" , :type => :api do
  
  context "Fetch Jogs" do    
    before do
      @jog = create(:jog)
      @user = @jog.user
      @manager = create(:manager)
      @admin = create(:admin)
    end
    
    it "fetches users jogs without auth token" do
      get "/users/#{@jog.user.id}/jogs"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty
    end
    
    it "fetches users jog" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
      
      get "/users/#{@jog.user.id}/jogs"
      expect(last_response.status).to eq 200
    end
    
    it "doesn't fetch other users jog" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
      
      get "/users/#{@manager.id}/jogs"
      expect(last_response.status).to eq 403
    end
    
    it "Fetch other users jog for manager role" do
      command = AuthenticateUser.call(@manager.email, @manager.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
      
      get "/users/#{@user.id}/jogs"
      expect(last_response.status).to eq 200
    end
    
    it "fetches other users jog for admin role" do
      command = AuthenticateUser.call(@admin.email, @admin.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
      
      get "/users/#{@user.id}/jogs"
      expect(last_response.status).to eq 200
    end
    
  end
  
  context "Fetches users jogs via filter" do
    before do
      @jog = create(:jog)
      @user = @jog.user
      @manager = create(:manager)
      @admin = create(:admin)
    end
    
    it "fetches users jog without auth token" do
      get "/users/#{@jog.user.id}/jogs/#{@jog.id}", { start_date: '2017-09-01', end_date: '2017-10-01' }
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty
    end
    
  end
  
  context "Fetch Jog" do
    before do
      @jog = create(:jog)
      @user = @jog.user
      @manager = create(:manager)
      @admin = create(:admin)      
    end
    
    it "fetches users jog without auth token" do
      get "/users/#{@jog.user.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty
    end

    it "fetches users jog" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      get "/users/#{@jog.user.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 200
    end
    
    it "doesn't fetch other users jog" do
      command = AuthenticateUser.call(@manager.email, @manager.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      get "/users/#{@jog.user.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 403
    end
    
    it "fetches any users jog for admin" do
      command = AuthenticateUser.call(@admin.email, @admin.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      get "/users/#{@jog.user.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 200      
    end
    
  end
  
  context "Update Jog" do
    before do
      @jog = create(:jog)
      @user = @jog.user
      @manager = create(:manager)
      @admin = create(:admin)      
    end

    it "updates users jog without auth token" do
      get "/users/#{@jog.user.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty
    end
    
    it "updates users jog" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      put "/users/#{@jog.user.id}/jogs/#{@jog.id}", { distance: 10}
      expect(last_response.status).to eq 204
    end
    
    it "updates other users jog" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      put "/users/#{@manager.id}/jogs/#{@jog.id}", { distance: 10}
      expect(last_response.status).to eq 403
    end    
    
    it "updates users jog with manager role" do
      command = AuthenticateUser.call(@manager.email, @manager.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      put "/users/#{@jog.user.id}/jogs/#{@jog.id}", { distance: 10}
      expect(last_response.status).to eq 403
    end
    
    it "updates users jog with admin role" do
      command = AuthenticateUser.call(@admin.email, @admin.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      put "/users/#{@jog.user.id}/jogs/#{@jog.id}", { distance: 10}
      expect(last_response.status).to eq 204
    end    
    
  end
  
  context "Delete Jog" do
    before do
      @jog = create(:jog)
      @user = @jog.user
      @manager = create(:manager)
      @admin = create(:admin)      
    end

    it "deletes users jog without auth token" do
      delete "/users/#{@jog.user.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty
    end
    
    it "deletes users jog" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      delete "/users/#{@jog.user.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 204
    end
    
    it "deletes other users jog" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      delete "/users/#{@manager.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 403
    end    
    
    it "deletes users jog with manager role" do
      command = AuthenticateUser.call(@manager.email, @manager.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      delete "/users/#{@jog.user.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 403
    end
    
    it "deletes users jog with admin role" do
      command = AuthenticateUser.call(@admin.email, @admin.password)
      token = command.result
      header "Authorization", "Bearer #{token}"
            
      delete "/users/#{@jog.user.id}/jogs/#{@jog.id}"
      expect(last_response.status).to eq 204
    end    
    
  end  
end
