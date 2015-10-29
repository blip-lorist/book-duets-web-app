require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before(:each) do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
  end

  # Shout out to Natasha the Robot's guide to writing OmniAuth session specs:
  # http://natashatherobot.com/rails-test-omniauth-sessions-controller/

  describe "POST #create" do
    it "creates a new user" do
      expect{post :create, provider: :twitter}.to change {User.count}.by(1)
    end

    it "creates a session" do
      post :create, provider: :twitter
      expect(session[:user_id]).to_not be_nil
      expect(session[:user_id]).to be_an_instance_of(Fixnum)
    end

    it "redirects to root_path" do
      post :create, provider: :twitter
      expect(response).to redirect_to(root_path)
    end
  end

  describe "DESTROY #delete" do

    it "destroys the session" do
      post :create, provider: :twitter
      expect(session[:user_id]).to_not be_nil
      get :destroy
      expect(session[:user_id]).to be_nil
    end
  end

  describe "PUT #language_filter" do

    it "saves filter level settings (safe, edgy, and filthy) in the session" do
      possible_settings = ["safe", "edgy", "filthy"]
      possible_settings.each do |setting|
        filter_setting = {level: setting}
        put :language_filter, filter_setting
        expect(session[:level]).to eq(setting)
      end
    end

  end

  describe "GET #failure" do
    it "redirects to root_path upon unsuccessful sign in" do
      get :failure
      expect(response).to redirect_to(root_path)
    end
  end
end
