require 'rails_helper'

RSpec.describe Question, type: :model do
  it_should_behave_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(100) }

  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
end
