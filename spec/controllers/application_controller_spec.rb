require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe "current_user" do
    it "locates the current user based on the session id" do
      signed_in_user = create :user, id: 1
      session[:user_id] = 1

      expect(controller.send(:current_user)).to eq(signed_in_user)
    end
  end

  describe "require_user" do
    context "when no one is logged in" do
      controller(ApplicationController) do
        before_action :require_user
        def require_user_test
          render text: 'response'
        end
      end

      before do
        routes.draw { get 'require_user_test' => 'anonymous#require_user_test' }
        get 'require_user_test'
      end

      it "redirects to registration / sign up page when no current_user is found" do
        expect(response).to redirect_to(account_path)
      end
    end
  end
end
