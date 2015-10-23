class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  before_create :create_activation_digest

  # ____ Associations ____
  has_many :book_duets
  has_many :mixtapes

  # ____ Validations ____
  validates :uid, :provider, :username, presence: true

  def authenticated?(attribute, token)
  digest = send("#{attribute}_digest")
  return false if digest.nil?
  BCrypt::Password.new(digest).is_password?(token)
  end
  
  private

  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(provider: auth_hash[:provider], uid: auth_hash[:uid]).first_or_create
    user.update(
      username: auth_hash[:info][:name]
    )
    if auth_hash["info"]["email"].present?
      email = auth_hash["info"]["email"].downcase
      user.update(email: email)
    end

    if user.save
      UserMailer.account_activation(user).deliver_now
    end

    return user.save ? user : nil
  end

  # Source credit: this tutorial - https://www.railstutorial.org/book/account_activation_password_reset
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end


end
