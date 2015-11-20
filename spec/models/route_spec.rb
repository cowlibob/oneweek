require 'rails_helper'

RSpec.describe Route, :type => :model do
  context "Valid GPX file" do
    let(:good_xml) {File.read(spec_data_path('Good Track.gpx'))}
    let(:route) {Route.new(name: 'Valid Route', xml: good_xml)}

    it "is valid XML" do
      expect(route.valid?).to be_truthy
    end

    it "reports distance travelled" do
      expect(route.total_distance_in_km.round(3)).to eq(0.933)
    end

    it "reports maximum speed" do
      expect(route.max_speed_in_kph.round(0)).to eq(42)
    end

    it "reports average speed" do
      approximated = (route.average_speed_in_kph / 0.5).floor.to_f * 0.5
      expect(approximated).to eq(13.5)
    end

    it "has no description" do
      no_description_xml = File.read(spec_data_path("No Description.gpx"))

      route = Route.new(name: 'no description', xml: no_description_xml)
      expect(route.valid?).to be_truthy
    end

  end

  context "Invalid GPX file" do
    it "is invalid XML" do
      bad_xml = File.read(spec_data_path('Bad Xml.gpx'))

      route = Route.new(name: 'Invalid Route', xml: bad_xml)
      expect(route.valid?).to be_falsey
    end

    it "is missing segment data" do
      missing_segment_xml = File.read(spec_data_path('No Segment.gpx'))

      route = Route.new(name: 'missing segment data', xml: missing_segment_xml)
      expect(route.valid?).to be_falsey
    end

    it "has no points" do
      no_points_xml = File.read(spec_data_path('No Tracks.gpx'))

      route = Route.new(name: 'empty route', xml: no_points_xml)
      expect(route.valid?).to be_falsey
    end

    it "has no name" do
      no_name_xml = File.read(spec_data_path("No Name.gpx"))

      route = Route.new(name: 'no_name', xml: no_name_xml)
      expect(route.valid?).to be_falsey
    end

    it "has no version" do
      no_version_xml = File.read(spec_data_path("No Version.gpx"))

      route = Route.new(name: 'no version', xml: no_version_xml)
      expect(route.valid?).to be_falsey
    end

    it "has no creator" do
      no_creator_xml = File.read(spec_data_path("No Creator.gpx"))

      route = Route.new(name: 'no creator', xml: no_creator_xml)
      expect(route.valid?).to be_falsey
    end

  end
  context "Missing GPX file" do
    it "must have a GPX file" do
      route = Route.new(name: 'No file')
      expect(route.valid?).to be_falsey
    end
  end

  context "Missing track name" do
    it "must have a name" do
      good_xml = File.read(spec_data_path('Good Track.gpx'))
      route = Route.new(xml: good_xml)
      expect(route.valid?).to be_falsey
    end
  end

  context "A Strava exported GPX file" do
    it "must be valid" do
      strava_xml = File.read(spec_data_path('Strava Export.gpx'))
      route = Route.new(name: 'Strava Export', xml: strava_xml)
      expect(route.valid?).to be_truthy
    end
  end
end
