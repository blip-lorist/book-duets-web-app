require 'rails_helper'

RSpec.describe MixtapesController, type: :controller do

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all mixtapes into @mixtapes" do
      book_duet1 = create :book_duet
      book_duet2 = create :book_duet
      get :index
      expect(assigns(:mixtapes)).to match_array([book_duet1, book_duet2])
    end
  end

  describe "GET #show" do

    before(:each) do
      @mixtape = create :mixtape
    end

    it "renders the show template" do
      get :show, id: @mixtape
      expect(response).to render_template("show")
    end

    it "loads the correct mixtape" do
      get :show, id: 1
      expect(assigns(:mixtape)).to eq(@mixtape)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do


    end
  end
end
