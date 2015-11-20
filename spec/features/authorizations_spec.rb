require 'rails_helper'

feature "Authorizations", :type => :feature do
  scenario "User logs in successfully" do
    create_routes_for_user('54321', ['Private Walk'])
    create_routes_for_user('12345', ['Quick Ride'])

    visit root_url

    mock_omniauth_hash('12345')
    click_link "login_btn"

    expect(page).to have_content('Welcome, mockuser')
    expect(page).to have_content('Routes')
    expect(page).to have_content('Quick Ride')
    expect(page).not_to have_content('Private Walk')
  end

  scenario "User fails to log in" do
    visit root_url

    failed_omniauth_hash
    click_link "login_btn"

    expect(page).to have_content('Sorry, we could not log you in.')
    expect(page).not_to have_content('Your Routes')
  end

  scenario "User logs out" do
    visit root_url

    mock_omniauth_hash('123545')
    click_link "login_btn"
    click_link "logout_btn"

    expect(page).to have_content('Login')
    expect(page).not_to have_content('Welcome, mockuser')
  end

end
