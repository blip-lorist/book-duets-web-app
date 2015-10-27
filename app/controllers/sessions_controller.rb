class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  MESSAGES = {
    auth_failure: "Sorry, your sign-in credentials are invalid!",
    auth_success: "Sign in successful!",
    filthy: "Pretty much Voldemort. May contain problematic language, sexual content, and curse words.",
    edgy: "All swearing allowed, you rebel.",
    safe: "Three cheers for censors! @#$ *!@ !@@#$%!",
    logout_success: "See ya!"
  }

  def language_filter
    if params[:level] == "filthy"
      session[:level] = "FILTHY"
      flash[:danger] = MESSAGES[:filthy]
    elsif params[:level] == "edgy"
      session[:level] = "EDGY"
      flash[:warning] = MESSAGES[:edgy]
    elsif params[:level] == "safe"
      session[:level] = "SAFE"
      flash[:success] = MESSAGES[:safe]
    end

    redirect_to root_path
  end

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)

    if @user.id != nil
      session[:user_id] = @user.id
      flash[:success] = MESSAGES[:auth_success]
      redirect_to root_path
    else
      flash[:errors] = MESSAGES[:auth_failure]
      redirect_to root_path
    end
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
