require 'rails_helper'

RSpec.describe MixtapesController, type: :controller do

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all mixtapes into @mixtapes" do
      mixtape1 = create :mixtape
      mixtape2 = create :mixtape
      get :index
      expect(assigns(:mixtapes)).to match_array([mixtape1, mixtape2])
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
      create :mixtape # not sure why the primary key doesn't reset to 1 in pg test
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
      let(:valid_params) do
        {name: "Ironical mashups", description: "Ironful irony."}
      end

      it "creates a new mixtape" do
        post :create, mixtape: valid_params
        expect(Mixtape.count).to eq(1)
      end
    end
  end
end
