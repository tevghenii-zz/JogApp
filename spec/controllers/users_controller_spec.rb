require "spec_helper"  
require 'jwt'

describe "JoggingTracker REST API" , :type => :api do
  
  context "Register" do
    
    before do
      @user = create(:user)
    end
    
    it "registers user successfully" do
      post "/users", { name: 'John Smith', email: 'john@mobex.md', password: '123456789', password_confirmation: '123456789' }
      expect(last_response.status).to eq 201            
      expect(json['data']['password_digest']).not_to be_empty
      expect(json['data']['id']).to eq 2
      expect(json['data']['email']).to eq 'john@mobex.md'
      expect(json['data']['name']).to eq 'John Smith'      
    end
    
    it "registers with email alreaded in the system" do
      post "/users", { name: 'John Smith', email: @user.email, password: '123456789', password_confirmation: '123456789' }      
      expect(last_response.status).to eq 422
      expect(json['message']).not_to be_empty
    end
    
    it "has no name param" do
      post "/users", { email: 'john@mobex.md', password: '123456789', password_confirmation: '123456789' }
      expect(last_response.status).to eq 422
      expect(json['message']).not_to be_empty
    end
    
    it "has no email param" do
      post "/users", { email: 'john@mobex.md', password: '123456789', password_confirmation: '123456789' }
      expect(last_response.status).to eq 422
      expect(json['message']).not_to be_empty
    end
    
    it "has no password param" do
      post "/users", { name: 'Jogn Smith', email: 'john@mobex.md', password_confirmation: '123456789' }
      expect(last_response.status).to eq 422
      expect(json['message']).not_to be_empty
    end
    
    it "has a short password (< 6 symbols)" do
      post "/users", { name: 'Jogn Smith', email: 'john@mobex.md', password: '1234' }
      expect(last_response.status).to eq 422
      expect(json['message']).not_to be_empty
    end
    
    it "has no password_confirmation param" do
      post "/users", { name: 'Jogn Smith', email: 'john@mobex.md', password: '123456789' }
      expect(last_response.status).to eq 422
      expect(json['message']).not_to be_empty
    end
    
    it "has a short password_confirmation (< 6 symbols)" do
      post "/users", { name: 'Jogn Smith', email: 'john@mobex.md', password: '123456789', password_confirmation: '1234' }
      expect(last_response.status).to eq 422
      expect(json['message']).not_to be_empty
    end
    
    it "password and its confirmation doesn't match" do
      post "/users", { name: 'Jogn Smith', email: 'john@mobex.md', password: '123456789', password_confirmation: '123456780' }
      expect(last_response.status).to eq 422
      expect(json['message']).not_to be_empty
    end
    
  end
  
  context "get users list" do
    before do
      @user = create(:user)
      @manager = create(:manager)
      @admin = create(:admin)
    end
    
    it "user is not logged in" do            
      get "/users"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty      
    end
    
    it "user has no permissions to read users's list" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      get "/users"
      expect(last_response.status).to eq 403
      expect(json['message']).not_to be_empty
    end
        
    it "manager has no permissions to read users's list" do
      command = AuthenticateUser.call(@manager.email, @manager.password)
      token = command.result      
      header "Authorization", "Bearer #{token}"
      
      get "/users"
      expect(last_response.status).to eq 403
    end        

    it "admin has permissions to read users's list" do
      command = AuthenticateUser.call(@admin.email, @admin.password)
      token = command.result      
      header "Authorization", "Bearer #{token}"
      
      get "/users"
      expect(last_response.status).to eq 200
    end    
    
  end
  
  context "fetch user profile" do
    before do
      @user = create(:user)
      @manager = create(:manager)
      @admin = create(:admin)
    end
    
    it "user is not logged in" do            
      get "/users/#{@user.id}"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty      
    end
    
    it "user has permissions to fetch his profile" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      get "/users/#{@user.id}"
      expect(last_response.status).to eq 200
    end
    
    it "user has no permissions to fetch other profile" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      get "/users/#{@manager.id}"
      expect(last_response.status).to eq 403
    end
    
    it "manager has permissions to fetch any profile" do      
      command = AuthenticateUser.call(@manager.email, @manager.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      get "/users/#{@user.id}"
      expect(last_response.status).to eq 200
    end
    
    it "admin has permissions to fetch any profile" do      
      command = AuthenticateUser.call(@admin.email, @admin.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      get "/users/#{@user.id}"
      expect(last_response.status).to eq 200
    end
  end
  
  context "update users" do
    before do
      @user = create(:user)
      @manager = create(:manager)
      @admin = create(:admin)
    end
    
    it "user is not logged in" do            
      put "/users/#{@user.id}"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty      
    end    
        
    it "user has permissions to update his user" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      put "/users/#{@user.id}"
      expect(last_response.status).to eq 204
    end
    
    it "user has no permissions to update other user" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      put "/users/#{@manager.id}"
      expect(last_response.status).to eq 403
    end
    
    it "manager has permissions to update any other user profile" do
      command = AuthenticateUser.call(@manager.email, @manager.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      put "/users/#{@user.id}"
      expect(last_response.status).to eq 204
    end 
    
    it "admin has permissions to update any other user profile" do
      command = AuthenticateUser.call(@admin.email, @admin.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      put "/users/#{@user.id}"
      expect(last_response.status).to eq 204
    end            
  end
  
  context "delete users" do
    before do
      @user = create(:user)
      @manager = create(:manager)
      @admin = create(:admin)
    end
    
    it "user is not logged in" do            
      delete "/users/#{@user.id}"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty      
    end    
        
    it "user has permissions to delete his user" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      delete "/users/#{@user.id}"
      expect(last_response.status).to eq 204
    end
    
    it "user has no permissions to delete other user" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      delete "/users/#{@manager.id}"
      expect(last_response.status).to eq 403
    end
    
    it "manager has permissions to delete any other user profile" do
      command = AuthenticateUser.call(@manager.email, @manager.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      delete "/users/#{@user.id}"
      expect(last_response.status).to eq 204
    end 
    
    it "admin has permissions to delete any other user profile" do
      command = AuthenticateUser.call(@admin.email, @admin.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      delete "/users/#{@user.id}"
      expect(last_response.status).to eq 204
    end
            
  end
  
  context "fetch my profile" do
    before do
      @user = create(:user)
    end
    
    it "user is not logged in" do            
      get "/me"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty      
    end    
        
    it "user has permissions to fetch his profile" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      get "/me"
      expect(last_response.status).to eq 200
    end
  end
  
  context "update user role" do
    before do
      @user = create(:user)
      @manager = create(:manager)
      @admin = create(:admin)
    end
    
    it "user is not logged in" do            
      put "/role/#{@user.id}"
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty      
    end
    
    it "user has no permissions to change roles" do
      command = AuthenticateUser.call(@user.email, @user.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      put "/role/#{@user.id}", { role: 'admin' }
      expect(last_response.status).to eq 403
    end
    
    it "manager has no permissions to change roles" do
      command = AuthenticateUser.call(@manager.email, @manager.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      put "/role/#{@user.id}", { role: 'admin' }
      expect(last_response.status).to eq 403
    end
    
    it "admin has permissions to change roles" do
      command = AuthenticateUser.call(@admin.email, @admin.password)
      token = command.result
      header "Authorization", "Bearer #{token}"

      put "/role/#{@user.id}", { role: 'admin' }
      expect(last_response.status).to eq 204
    end    
    
  end
    
end
