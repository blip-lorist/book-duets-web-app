class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  before_create :create_activation_digest
  after_create :email_auth_key

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
    # Check if email is present (Identity users)
    if auth_hash["info"]["email"].present?
      # downcase the email input
      email = auth_hash["info"]["email"].downcase
      # Find or create with email
      user = where(provider: auth_hash[:provider], uid: auth_hash[:uid], email: email).first_or_create
    else
      # Create a user record without an email
      user = where(provider: auth_hash[:provider], uid: auth_hash[:uid]).first_or_create
    end
    user.update(
      username: auth_hash[:info][:name]
    )
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

  # This is triggered upon user creation when email is present
  def email_auth_key
    #Only send email if they're using Identity provider
    if self.provider == "identity"
      UserMailer.account_activation(self).deliver_now
    end
  end

end
