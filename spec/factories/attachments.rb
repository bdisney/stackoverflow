include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :attachment do
    file { fixture_file_upload("#{Rails.root}/spec/files/test_image_1.png", 'image/png') }
  end
end
