module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      {
        'provider' => provider.to_s,
        'uid' => '123545',
        'user_info' => {
            'name' => 'mockuser',
            'image' => 'mock_user_thumbnail_url'
        },
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        }
      }.merge(provider == :facebook ? {info: { email: 'fb@test.ru'} } : {})
    )
  end
end
