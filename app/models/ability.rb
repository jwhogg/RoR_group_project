# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, Elective
      can :manage, Question
    else
      can [:read], Elective
    end
  
    
  end
end
