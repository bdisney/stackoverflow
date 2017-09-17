require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.html { redirect_to root_path, alert: e.message }
      format.json { head :forbidden }
      format.js   { render json: { error: e.message }, status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end
end
