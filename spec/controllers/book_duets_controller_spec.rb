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
      get :suggested_pairing
      expect(response).to render_template("suggested_pairing")
    end
  end

end
