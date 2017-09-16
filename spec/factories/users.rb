FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user do
    email
    password '123456'
    password_confirmation '123456'

    before(:create) do |user|
      user.skip_confirmation!
    end
  end
end
