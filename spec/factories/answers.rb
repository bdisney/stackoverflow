FactoryGirl.define do
  factory :answer do
    body 'SomeText'
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
    user
  end
end
