class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :identities, dependent: :destroy

  def author_of?(resource)
    resource.user_id == id
  end

  def self.find_for_oauth(auth)
    identity = Identity.where(provider: auth.provider, uid: auth.uid.to_s).first
    return identity.user if identity

    email = auth.info.try(:[], :email)
    user = User.where(email: email).first

    if user
      user.create_identity(auth)
    elsif email
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)

      user.create_identity(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create(password: password, password_confirmation: password)
    end

    user
  end

  def create_identity(auth)
    self.identities.create(provider: auth.provider, uid: auth.uid)
  end
end
