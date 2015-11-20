def create_routes_for_user(user_id, route_names)
  xml = File.read(spec_data_path('Good Track.gpx'))
  route_names.each do |route_name|
    Route.create(name: route_name, user_id: user_id, xml: xml)
  end
end

def spec_data_path(filename)
  Rails.root.join('spec', 'data', filename)
end
