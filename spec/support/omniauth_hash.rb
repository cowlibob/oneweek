module OmniauthHash
  def mock_omniauth_hash(uid)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => uid,
      'info' => {
        'nickname' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end

  def failed_omniauth_hash
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end

  def login_user(user_id = '12345')
    visit root_url
    mock_omniauth_hash(user_id)
    click_link "login_btn"
  end

end
