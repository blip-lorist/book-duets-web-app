class User < ActiveRecord::Base
  # ____ Associations ____
  has_many :book_duets
  has_many :mixtapes


  # ____ Validations ____
  validates :uid, :provider, :username, presence: true

  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(provider: auth_hash[:provider], uid: auth_hash[:uid]).first_or_create
    user.update(
      username: auth_hash[:info][:name]
    )
    if auth_hash["info"]["email"].present?
      user.update(email: auth_hash["info"]["email"])
    end
    return user.save ? user : nil
  end
end
