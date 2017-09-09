class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_auth
  before_action :request_email, only: :facebook
  before_action :default_callback

  def facebook
  end

  def twitter
  end

  private

  def set_auth
    @auth = request.env['omniauth.auth']
  end

  def request_email
    if @auth.info.email.blank?
      redirect_to '/users/auth/facebook?auth_type=rerequest&scope=email'
    end
  end

  def default_callback
    @user = User.find_for_oauth(@auth)
    if @user && @user.persisted?
      sign_in_and_redirect(@user, event: :authentication)
      set_flash_message(:notice, :success, kind: @auth.provider.capitalize) if is_navigational_format?
    end
  end
end
