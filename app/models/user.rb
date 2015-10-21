class User < ActiveRecord::Base

  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(provider: auth_hash[:provider], uid: auth_hash[:uid]).first_or_create
    user.update(
      username: auth_hash[:info][:name],
      profile_image: auth_hash[:info][:image]
    )
    user
  end
end
