class MixtapesController < ApplicationController
  before_action :require_user
  before_action :require_owner, only: [:show, :edit, :update, :destroy]

  MESSAGES = {
    create_success: "You've successfully created a mixtape.",
    create_fail: "Sorry, this mixtape couldn't be saved. Please try again.",
    edit_success: "You've successfully edited your mixtape!",
    edit_failure: "Sorry, this mixtape couldn't be edited. Please try again.",
    remove_duet: "You've successfully removed a Book Duet from this mixtape.",
    login: "Please log in to view that page.",
    go_away: "That's not your mixtape!"
  }

  def index
    user_id = session[:user_id]
    @mixtapes = Mixtape.where(user_id: user_id)
  end

  def new
    @mixtape = Mixtape.new
  end

  def show
    @mixtape = Mixtape.find(params[:id])
  end

  def create
    @mixtape = Mixtape.new(mixtape_params)
    @mixtape.user_id = session[:user_id]

    if @mixtape.save
      flash[:success] = MESSAGES[:create_success]
      redirect_to mixtapes_path
    else
      flash[:errors] = MESSAGES[:create_fail]
      render :new
    end
  end

  def edit
    @mixtape = Mixtape.find(params[:id])
  end

  def update
    @mixtape = Mixtape.find(params[:id])
    @mixtape.update(mixtape_params)
    if @mixtape.save
      flash[:success] = MESSAGES[:edit_success]
      redirect_to mixtape_path(@mixtape)
    else
      flash[:errors] = MESSAGES[:edit_failure]
      render :edit
    end
  end

  def destroy
    @mixtape = Mixtape.find(params[:id])
    @mixtape.destroy

    redirect_to mixtapes_path
  end

  def remove_book_duet
    mixtape = Mixtape.find(params[:mixtape_id])
    book_duet = BookDuet.find(params[:id])
    collection = mixtape.book_duets
    collection.delete(book_duet)

    flash[:success] = MESSAGES[:remove_duet]
    redirect_to mixtape_path(mixtape)
  end

  private

  def mixtape_params
    params.require(:mixtape).permit(:title, :description)
  end

  def require_owner
    if !current_user
      flash[:errors] = MESSAGES[:login]
      redirect_to root_path
    elsif !current_user.mixtapes.exists?(id: params[:id])
      flash[:errors] = MESSAGES[:go_away]
      redirect_to mixtapes_path
    end
  end
end
