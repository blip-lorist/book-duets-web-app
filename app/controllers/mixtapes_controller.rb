class MixtapesController < ApplicationController

  MESSAGES = {
    create_success: "You've successfully created a mixtape.",
    create_fail: "Sorry, this mixtape couldn't be saved. Please try again.",
    edit_success: "You've successfully edited your mixtape!",
    edit_failure: "Sorry, this mixtape couldn't be edited. Please try again."
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

  def update
    @mixtape = Mixtape.find(params[:id])
    @mixtape.update(mixtape_params)
    if @mixtape.save
      flash[:success] = MESSAGES[:edit_success]
      redirect_to mixtapes_path
    else
      flash[:failure] = MESSAGES[:edit_failure]
      render :edit
    end

  end

def destroy
  @mixtape = Mixtape.find(params[:id])
  @mixtape.destroy

  redirect_to mixtapes_path
end
  private

  def mixtape_params
    params.require(:mixtape).permit(:title, :description)
  end

end
