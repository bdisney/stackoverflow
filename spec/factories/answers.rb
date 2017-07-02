FactoryGirl.define do
  factory :answer do
    body 'SomeText'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
  end
end
