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
end
