module OmniauthMacros
  OmniAuth.config.test_mode = true

  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = OmniAuth::AuthHash.new(
        {
            'provider' => provider,
            'uid' => '123456',
            'info' => { 'email' => 'user@test.com' },
            'credentials' => {
                'token' => 'mock_token',
                'secret' => 'mock_secret'
            }
        })
  end

  def mock_auth_invalid_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = :invalid_credentials
  end
end
