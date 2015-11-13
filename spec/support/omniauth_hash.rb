module OmniauthHash
  def mock_omniauth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '123545',
      'info' => {
        'nickname' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })

    def failed_omniauth_hash
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    end
  end
end
