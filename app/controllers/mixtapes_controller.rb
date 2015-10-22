class MixtapesController < ApplicationController

  def new
    @mixtape = Mixtape.new
  end

  def create
    @mixtape = Mixtape.new(mixtape_params)
    @mixtape.user = @current_user

    if @mixtape.save
      flash[:success] = MESSAGES[:create_success]
      redirect_to profile_path
    else
      flash[:errors] = MESSAGES[:create_fail]
      render :new
    end
  end
end
