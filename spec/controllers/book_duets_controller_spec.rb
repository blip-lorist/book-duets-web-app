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

    it "authenticates the client and response with success" do
      VCR.use_cassette 'controllers/suggested_pairing', :record => :once do
        get :suggested_pairing
        binding.pry
        expect(response.response_code).to_not be(401)
        expect(response.response_code).to be(200)
      end
    end

    it "retrieves a JSON object" do
      VCR.use_cassette 'controllers/suggested_pairing', :record => :once do
        get :suggested_pairing
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end

    it "has a JSON response with musician, author, book_duet, and news_source keys" do
    end
  end

end
