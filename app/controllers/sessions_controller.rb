class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  MESSAGES = {
    auth_failure: "Sorry, your sign-in credentials are invalid!",
    auth_success: "Sign in successful!",
    logout_success: "See ya!"
  }

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    flash[:success] = MESSAGES[:auth_success]
    redirect_to root_path
  end

  def failure
    flash[:errors] = MESSAGES[:auth_failure]
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = MESSAGES[:logout_success]
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
