require 'rails_helper'

feature "Routes", :type => :feature do
  scenario "Add first route" do
    login_user

    click_link('add_route')
    fill_in('route_name', with: 'Track 011')
    page.attach_file('route_xml', Rails.root.join('spec', 'data', 'Track 011.gpx'))
    click_button('upload_btn')

    expect(page).to have_content('Successfully')
    expect(page).to have_content('Track 011')

  end
end
