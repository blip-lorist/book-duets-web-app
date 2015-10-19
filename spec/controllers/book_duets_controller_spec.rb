require 'rails_helper'

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
        get :suggested_pairing
        expect(response).to render_template("suggested_pairing")
      end
    end

    it "retrieves suggested_pairing with musician, author, book_duet, and news_source keys" do
      VCR.use_cassette 'controllers/suggested_pairing', :record => :once do
        get :suggested_pairing
        keys = ["musician", "author", "book_duet", "news_source"]
        keys.each do |key|
          suggested_pairing = JSON.parse(response)
          expect(suggested_pairing.keys).to include(key)
        end
      end
    end
  end

end
