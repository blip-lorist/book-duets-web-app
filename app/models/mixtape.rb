class Mixtape < ActiveRecord::Base
  # ____ Associations ____
  has_and_belongs_to_many :book_duets, join_table: "book_duets_mixtapes"
  belongs_to :user
  # ____ Scopes ____
  # scope :newest, -> (total) { order("created_at DESC").limit(total) }
end
