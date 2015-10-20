class BookDuetsController < ApplicationController

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
  end
end
