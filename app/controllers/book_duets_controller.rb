class BookDuetsController < ApplicationController

  require "HTTParty"

  if Rails.env.production?
    BASE_URI = "blah.blah"
  else
    BASE_URI = "http://localhost:3333"
  end

  def index
  end

  def suggested_pairing
    @suggested_pairing = HTTParty.get(BASE_URI + "/suggested_pairing", :headers => {
      "Book-Duets-Key" => ENV['BOOK_DUETS_API_KEY'] })
    # Magic happens here to call API and return a suggested pairing
  end

  def custom_duet (musician, artist)
    @custom_duet = HTTParty.get(BASE_URI + "/custom_duet?musician=#{musician}&artist=#{artist}", :headers => {
      "Book-Duets-Key" => ENV['BOOK_DUETS_API_KEY'] })
    # Magic happens here to call API and return a custom duet
  end
end
