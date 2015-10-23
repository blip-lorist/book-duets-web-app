class UsersController < ApplicationController


  def show
    @user = User.find(session[:user_id])
    @book_duets = @user.book_duets
    @mixtapes = @user.mixtapes
    # Show last five saved BookDuets
    # Show mixtapes
  end
end
