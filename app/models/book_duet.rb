class BookDuet < ActiveRecord::Base
  has_many :mixtapes
  has_many :users, through: :mixtapes
  belongs_to :user
end
