require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(
    username: "unigoat",
    uid:      "666",
    provider: "twitter",
    profile_image: "unigoat.jpg")
  }

  describe "validations" do
    it "is valid" do
      expect(user).to be_valid
    end

    it "requires a username" do
      user.username = nil
      expect(user).to be_invalid
    end

    it "requires a uid" do
      user.uid = nil
      expect(user).to be_invalid
    end

    it "requires a provider" do
      user.provider = nil
      expect(user).to be_invalid
    end
  end
end
