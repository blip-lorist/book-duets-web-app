class BookDuet < ActiveRecord::Base
  # ____ Associations ____
  has_and_belongs_to_many :mixtapes, join_table: "book_duets_mixtapes"
  belongs_to :user
end
