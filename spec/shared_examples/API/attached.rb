shared_examples_for 'API attached' do
  let!(:attachment) { create(:attachment, attachable: attachable) }

  before { get path, params: { format: :json, access_token: access_token.token } }

  it 'contains attachments list' do
    expect(response.body).to have_json_size(1).at_path("attachments")
  end

  it 'each attachment contains attribute name' do
    expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
  end
end
