require "erb"
include ERB::Util
require "HTTParty"

class BookDuetsController < ApplicationController
  before_action :setup_book_duet, only: [:show, :add_to_mixtape, :edit]
  before_action :set_book_duet, only: [:show, :setup_book_duet, :add_to_mixtape]
  before_action :require_user, only: [:create, :add_to_mixtape]

  MESSAGES = {
    create_success: "You've successfully saved a BookDuet.",
    create_fail: "Sorry, this BookDuet couldn't be saved.",
    cant_find_author: "This author couldn't be found. Please check the spelling and try again.",
    cant_find_musician: "This musician couldn't be found. Please check the spelling and try again."
  }

  if Rails.env.production?
    BASE_URI = "blah.blah"
  else
    BASE_URI = "http://localhost:3333"
  end

  def index
    @book_duets = BookDuet.all

    @adj = %w(fiendish clever wicked illuminating snappy thoughtful philosophical tactful wild lively keen perverse)
  end

  def custom_duet_redirect
    if params[:musician].present? && params[:author].present?
      # Make this url friendly
      musician = url_cleaner(params[:musician])
      author = url_cleaner(params[:author])
      level =  session[:level] || "safe"

      redirect_to custom_duet_path(musician, author, level)
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
    musician = params["musician"]
    author = params["author"]
    filter = params["level"]

    if filter == "safe"
      level = "hi"
    elsif filter == "edgy"
      level = "med"
    elsif filter == "filthy"
      level = "none"
    end

    # Call API and return a custom duet
    @custom_duet = HTTParty.get(BASE_URI + "/custom_duet?musician=#{musician}&author=#{author}&filter_level=#{level}", :headers => {
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
    user_id: session[:user_id],
    filter_level: params[:filter_level])
    
    if @book_duet.save
      flash[:success] = MESSAGES[:create_success]
    else
      flash[:errors] = MESSAGES[:create_fail]
    end

    redirect_to book_duets_path
  end

  def show
  end

  # Mahalo to @arhx - this part is heavily influenced by her
  # cookbooks code in our AdaCooks project!
  def add_to_mixtape
    mixtape_id = params[:mixtape][:mixtape_id]
    mixtape = Mixtape.find(mixtape_id)
    @book_duet.mixtapes << mixtape

    if @book_duet.mixtapes.exists?(id: mixtape_id)
      flash[:success] = "You successfully saved this Book Duet to your mixtape."
      redirect_to mixtape_path(mixtape_id)
    else
      flash[:failure] = "Sorry, that Book Duet couldn't be saved to your mixtape."
      render :show
    end
  end

  private

  def url_cleaner(name)
    # Formatting initials for API
    name = name.gsub(/(?<=[A-Z]\.)(?=[A-Z].)+/, ' ')
    # Titlecase the name
    titlecase_name = name.titlecase
    # Encode for URI
    name_encoded = url_encode(titlecase_name)

    return name_encoded
  end

  def set_book_duet
    @book_duet = BookDuet.find(params[:id])
  end

  def setup_book_duet
    @book_duet = BookDuet.find(params[:id])
    unless current_user == nil || current_user.mixtapes.empty?
      id = current_user.id
      @unused_mixtapes = current_user.mixtapes - @book_duet.mixtapes
      @your_mixtapes = @book_duet.mixtapes.where(user: id)
    end
  end
end
