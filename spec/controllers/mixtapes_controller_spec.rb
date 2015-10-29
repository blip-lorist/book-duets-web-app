require 'rails_helper'

RSpec.describe MixtapesController, type: :controller do

  # Skip the authentication for testing porpoises
  before(:each) do
    MixtapesController.skip_before_filter :require_user
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all mixtapes into @mixtapes" do
      mixtape1 = create :mixtape
      mixtape2 = create :mixtape
      session[:user_id] = 1

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
        {title: "Ironical mashups", description: "Ironful irony."}
      end

      it "creates a new mixtape" do
        session[:user_id] = 1
        post :create, mixtape: valid_params
        expect(Mixtape.count).to eq(1)
      end
    end

    context "with invalid params" do

      before(:each) do
        session[:user_id] = 1
        post :create, mixtape: invalid_params
      end

      let(:invalid_params) do
        {title: nil, description: "Ironful irony."}
      end

      it "doesn't create the mixtape" do
        expect(Mixtape.count).to eq(0)
      end

      it "reloads the new template" do
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    before(:each) do
      @mixtape = create :mixtape
    end

    context "with valid params" do
      let(:new_mixtape_deets) do
        {title: "New title", description: "New desc"}
      end

      it "updates the mixtape" do
        put :update, id: @mixtape, mixtape: new_mixtape_deets
        @mixtape.reload
        expect(@mixtape.title).to eq("New title")
      end
    end

    context "with invalid params" do
      let(:missing_deets) do
        {title: nil, description: "New desc"}
      end

      it "doesn't update the mixtape" do
        create :mixtape
        put :update, id: @mixtape, mixtape: missing_deets
        @mixtape.reload
        expect(@mixtape.title).to eq("90s Jams")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @mixtape = create :mixtape
    end

    it "deletes the mixtape" do
      expect(Mixtape.count).to eq(1)
      delete :destroy, id: @mixtape
      expect(Mixtape.count).to eq(0)
    end
  end

  describe "DELETE remove_book_duet" do

    let(:remove_mixtape_params) do
      {mixtape_id: 1, id: 1}
    end

    it "removes a book_duet from a mixtape" do
      duet = create :book_duet, id: 1
      mixtape = create :mixtape, id: 1

      mixtape.book_duets << duet
      expect(mixtape.book_duets.count).to eq(1)

      delete :remove_book_duet, remove_mixtape_params
      expect(mixtape.book_duets.count).to eq(0)
    end
  end
end
