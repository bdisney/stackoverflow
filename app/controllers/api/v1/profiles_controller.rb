class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with other_users
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end

  def other_users
    @users = User.where.not(id: current_resource_owner.id) if current_resource_owner
  end
end
