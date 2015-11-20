require 'rails_helper'

feature "Routes", :type => :feature do
  scenario "Add first route" do
    login_user

    click_link('add_route')
    fill_in('route_name', with: 'Track 011')
    page.attach_file('route_xml', spec_data_path('Track 011.gpx'))
    click_button('upload_btn')

    expect(page).to have_content('Successfully')
    expect(page).to have_content('Track 011')

  end

  scenario "Remove a route" do
    Route.create(user_id: '12345', name: 'Route 1', xml: File.read(spec_data_path('Good Track.gpx')))

    login_user('12345')

    click_link('Route 1')
    click_button('Delete')

    expect(page).to have_content('Successfully')
    expect(page).not_to have_content('Route 1')
  end
end
