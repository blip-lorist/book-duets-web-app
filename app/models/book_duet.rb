class BookDuet < ActiveRecord::Base
  # ____ Associations ____
  has_and_belongs_to_many :mixtapes, join_table: "book_duets_mixtapes"
  belongs_to :user

  # ____ Validations ____
  validates :musician, :author, :duet_text, :user_id, presence: true

  # ____ Scopes ____
  scope :newest, -> { order("created_at DESC") }


end
