FactoryGirl.define do
  factory :comment do
    body 'Comment body'
    user
    association :commentable, factory: :question
  end
end