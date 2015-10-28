require 'rails_helper'

RSpec.describe Mixtape, type: :model do

  let(:mixtape) { Mixtape.new(
    title: "Zeitreise",
    description: "2005 was a funny year",
    user_id: 1)
  }

  describe "validations" do
    it "is valid" do
      expect(mixtape).to be_valid
    end

    it "requires a title" do
      mixtape.title = nil
      expect(mixtape).to be_invalid
    end

    it "requires a user_id" do
      mixtape.user_id = nil
      expect(mixtape).to be_invalid
    end
  end
end
