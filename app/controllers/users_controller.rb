class UsersController < ApplicationController

def show
  @user = User.find(session[:user_id])

  # Show last five saved BookDuets
  # Show mixtapes
end

end
