FactoryGirl.define do
  factory :identity do
    user
    provider 'facebook'
    uid '123456'
  end
end
