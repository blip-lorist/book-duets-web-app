require 'rails_helper'

RSpec.describe BookDuet, type: :model do
  let(:book_duet) { BookDuet.new(
    musician: "Ellie Goulding",
    author: "Octavia Butler",
    duet_text: "When emotion rules alone, Destruction...destruction. Only actions Guided and shaped By belief and knowledge Will save you. Joseph said.",
    filter_level: "filthy",
    user_id: 1)
  }

  describe "validations" do
    it "is valid" do
      expect(book_duet).to be_valid
    end

    it "requires a musician" do
      book_duet.musician = nil
      expect(book_duet).to be_invalid
    end

    it "requires a author" do
      book_duet.musician = nil
      expect(book_duet).to be_invalid
    end

    it "requires duet_text" do
      book_duet.duet_text = nil
      expect(book_duet).to be_invalid
    end

    it "requires a user_id" do
      book_duet.user_id = nil
      expect(book_duet).to be_invalid
    end
  end
end
