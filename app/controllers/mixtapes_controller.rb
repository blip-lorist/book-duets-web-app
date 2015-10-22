class MixtapesController < ApplicationController

  MESSAGES = {
    create_success: "You've successfully created a Mixtape.",
    create_fail: "Sorry, this Mixtape couldn't be saved. Please try again.",
  }

  def index
    @mixtapes = Mixtape.all
  end

  def new
    @mixtape = Mixtape.new
  end

  def create
    @mixtape = Mixtape.new(mixtape_params)
    @mixtape.user_id = session[:user_id]

    if @mixtape.save
      flash[:success] = MESSAGES[:create_success]
      redirect_to profile_path
    else
      flash[:errors] = MESSAGES[:create_fail]
      render :new
    end
  end

  private

  def mixtape_params
    params.require(:mixtape).permit(:title, :description)
  end

end
