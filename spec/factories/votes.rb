FactoryGirl.define do
  factory :vote do
    association :user
    association :votable, factory: :question, strategy: :create
    value 1

    factory :negative_vote do
      value -1
    end
  end
end
