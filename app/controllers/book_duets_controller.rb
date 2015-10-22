class BookDuetsController < ApplicationController

  MESSAGES = {
    create_success: "You've successfully saved a BookDuet.",
    create_fail: "Sorry, this BookDuet couldn't be saved.",
    cant_find_author: "This author couldn't be found. Please check the spelling and try again.",
    cant_find_musician: "This musician couldn't be found. Please check the spelling and try again."
  }

  require "HTTParty"

  if Rails.env.production?
    BASE_URI = "blah.blah"
  else
    BASE_URI = "http://localhost:3333"
  end

  def index; end

  def custom_duet_redirect
    if params[:musician].present? && params[:author].present?
      redirect_to custom_duet_path(params[:musician], params[:author])
    else
      redirect_to root_path
    end
  end

  def suggested_pairing
    # Call API and return a suggested pairing
    @suggested_pairing = HTTParty.get(BASE_URI + "/suggested_pairing", :headers => {
      "Book-Duets-Key" => ENV['BOOK_DUETS_API_KEY'] })
  end

  def custom_duet
    musician = params[:musician]
    author = params[:author]

    # Call API and return a custom duet
    @custom_duet = HTTParty.get(BASE_URI + "/custom_duet?musician=#{musician}&author=#{author}", :headers => {
      "Book-Duets-Key" => ENV['BOOK_DUETS_API_KEY'] })

    if @custom_duet["error"]
      if @custom_duet["error"] == "AuthorNotFound"
        flash[:errors] = MESSAGES[:cant_find_author]
      elsif @custom_duet["error"] == "LyricsNotFound"
        flash[:errors] = MESSAGES[:cant_find_musician]
      end
    end
  end

  def create
    @book_duet = BookDuet.create(
    musician: params[:musician],
    author: params[:author],
    duet_text: params[:book_duet],
    user_id: session[:user_id])

    if @book_duet.save
      flash[:success] = MESSAGES[:create_success]
    else
      flash[:errors] = MESSAGES[:create_fail]
    end
    redirect_to root_path
  end
end
