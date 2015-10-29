require 'rails_helper'
require "erb"
include ERB::Util

RSpec.describe BookDuetsController, type: :controller do

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #suggested_pairing" do
    it "renders the suggested_pairing template" do
      VCR.use_cassette 'controllers/suggested_pairing', :record => :once do
        get :suggested_pairing, level: "safe"
        expect(response).to render_template("suggested_pairing")
      end
    end

    it "retrieves suggested_pairing with musician, author, book_duet, and news_source keys" do
      VCR.use_cassette 'controllers/suggested_pairing', :record => :once do
        get :suggested_pairing, level: "safe"

        keys = ["musician", "author", "book_duet", "news_source", "filter_level"]
        keys.each do |key|
          expect(assigns(:suggested_pairing).keys).to include(key)
        end
      end
    end
  end

  describe "custom_duet_redirect" do
    it "redirects if both a musician and author aren't provided in custom duet form" do
      get :custom_duet_redirect, :musician => "Weird Al"
      expect(response).to redirect_to(root_path)
    end

    it "redirects to custom_duet if both musician and author are provided" do
      get :custom_duet_redirect, :musician => "Weird Al", :author => "William S. Burroughs", level: "safe"
      musician = url_encode("Weird Al")
      author = url_encode("William S. Burroughs")
      level = "safe"

      expect(response).to redirect_to(custom_duet_path(musician, author, level))
    end
  end

  describe "GET #custom_duet" do
    context "with valid params" do
      it "renders the custom_duet template" do
        VCR.use_cassette 'controllers/custom_duet', :record => :once do
          get :custom_duet, :musician => "Kesha", :author => "Karl Marx", level: "safe"
          expect(response).to render_template("custom_duet")
        end
      end

      it "receives custom_duet with musician, author, book_duet, and news_source keys" do
        VCR.use_cassette 'controllers/custom_duet', :record => :once do
          get :custom_duet, :musician => "Kesha", :author => "Karl Marx", level: "safe"
          keys = ["musician", "author", "book_duet"]
          keys.each do |key|
            expect(assigns(:custom_duet).keys).to include(key)
          end
        end
      end
    end

    context "when an author can't be found" do
      it "flashes an error and redirects to the root path" do
        VCR.use_cassette 'controllers/custom_duet_missing_author', :record => :once do
          get :custom_duet, :musician => "Kesha", :author => "asdf", level: "safe"
          expect(flash[:errors]).to eq("This author couldn't be found. Please check the spelling and try again.")
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "when a musician can't be found" do
      it "flashes an error and redirects to the root path" do
        VCR.use_cassette 'controllers/custom_duet_missing_musician', :record => :once do
          get :custom_duet, :musician => "asdf", :author => "Octavia Butler", level: "safe"
          expect(flash[:errors]).to eq("This musician couldn't be found. Please check the spelling and try again.")
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "when the api is down" do
      it "flashes an error and redirects to the root path" do
        VCR.use_cassette 'controllers/api_unreachable', :record => :once do
          get :custom_duet, :musician => "Portishead", :author => "Octavia Butler", level: "safe"
          expect(flash[:errors]).to eq("Sorry, something went wrong. Please try again later!")
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  before(:each) do
    BookDuetsController.skip_before_filter :require_user
  end

  describe "POST #create" do

    let(:book_duet_params) do
      {musician: "Angel Haze",
      author: "Shirley Jackson",
      book_duet: "Sick and tired of falling in the face of Hill House, and whatever walked there, walked alone.",
      filter_level: "edgy"}
    end

    it "creates a book duet" do
      session[:user_id] = 1
      post :create, book_duet_params

      expect(BookDuet.count).to eq(1)
    end
  end

  describe "POST #add_to_mixtape" do
    it "adds a BookDuet to a mixtape" do
      mixtape = create :mixtape, id: 1
      duet = create :book_duet
      params = {id: duet.id, mixtape: {mixtape_id: 1}}
      post :add_to_mixtape, params

      expect(mixtape.book_duets.count).to eq(1)
    end
  end
end
