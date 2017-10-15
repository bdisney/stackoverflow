class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    alias_action :vote_up, :vote_down, to: :vote
    alias_action :update, :destroy, to: :manage_own

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :manage_own, [Question, Answer], user_id: user.id
    can :destroy, Comment, user_id: user.id

    can :vote, [Question, Answer] do |resource|
      resource.user_id != user.id
    end

    can :accept, Answer, question: { user_id: user.id }

    can :me, User

    can :manage, User

    can :create, Subscription do |subscription|
      !user.subscribed_for?(subscription)
    end

    can :destroy, Subscription, user: user
  end

  def admin_abilities
    can :manage, :all
  end
end
