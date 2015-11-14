require 'rails_helper'

feature "Authorizations", :type => :feature do
  scenario "User logs in successfully" do
    visit root_url

    mock_omniauth_hash
    click_link "login_btn"

    expect(page).to have_content('Welcome, mockuser')
    expect(page).to have_content('Routes')
  end

  scenario "User fails to log in" do
    visit root_url

    failed_omniauth_hash
    click_link "login_btn"

    expect(page).to have_content('Sorry, we could not log you in.')
    expect(page).not_to have_content('Your Routes')
  end

end
