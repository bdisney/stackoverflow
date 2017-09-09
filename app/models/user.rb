class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :identities, dependent: :destroy

  def author_of?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    return if auth.blank?

    identity = Identity.find_or_initialize_by(provider: auth.provider, uid: auth.uid.to_s)
    return identity.user if identity.persisted?

    user = User.find_or_initialize_by(email: auth.info[:email])
    transaction do
      unless user.persisted?
        password = Devise::friendly_token(10)
        user.assign_attributes(password: password, password_confirmation: password)
        user.save!
      end
      identity.user = user
      identity.save!
    end
    user
  end
end
