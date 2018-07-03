require "spec_helper"  
require 'jwt'

describe "JoggingTracker REST API" , :type => :api do
  
  context "Login" do
  
    before do
      @user = create(:user)
    end
    
    it "logs in with no email param" do
      post "/login", { password: '12121212121212' }
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty
    end
    
    it "logs in with no password" do
      post "/login", { email: 'any@mobex.md' }
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty
    end
        
    it "logs in with wrong credentials" do
      post "/login", { email: 'any@mobex.md', password: '12121212121212' }
      expect(last_response.status).to eq 401
      expect(json['message']).not_to be_empty
    end
    
    it "logs in with correct credentials" do
      post "/login", { email: 'evghenii@mobex.md', password: '123456789' }
      expect(last_response.status).to eq 200
      expect(json['data']['auth_token']).not_to be_empty      
    end
    
  end

end
