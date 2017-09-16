class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sing_in_or_register

  def facebook
  end

  def twitter
  end

  def register
  end

  private

  def sing_in_or_register
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
    else
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      render 'omniauth_callbacks/add_email', locals: { auth_hash: auth}
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params['auth_hash']).merge( { provider: session[:provider], uid: session[:uid] } )
  end
end