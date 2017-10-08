shared_examples_for 'API commented' do
  let!(:comment) { create(:comment, commentable: commentable) }

  before { get path, params: { format: :json, access_token: access_token.token } }

  it 'contains comments list' do
    expect(response.body).to have_json_size(1).at_path("comments")
  end

  %w(id body).each do |attr|
    it "each comment contains attribute #{attr}" do
      expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
    end
  end
end
