require "bigdecimal/math"
require "cmath"

class RouteValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    doc = Nokogiri::XML(record.xml)

    error(:xml, doc.errors)                                     if doc.errors.any?
    # error(:xml, "No Track Segments found (Invalid GPX file).")  if doc.css('trkseg').empty?
    error(:xml, "No Points found (Empty Route).")               if doc.css('trkpt, rtept').empty?
    error(:xml, "No Name (Invalid GPX file).")                  if doc.css('trk name, rte name').empty?
    # error(:xml, "No Description (Invalid GPX file).")           if doc.css('trk desc').empty?
    error(:xml, "No Version (Invalid GPX file).")               if doc.css('gpx[version]').empty?
    error(:xml, "No Creator (Invalid GPX file).")               if doc.css('gpx[creator]').empty?
  end

  private

  def error(attribute, message)
    @record.errors[attribute] << message
  end
end

class Route < ActiveRecord::Base
  include BigMath

  include ActiveModel::Validations
  validates_with RouteValidator

  validates :name, presence: true

  before_save :calculate_stats


  # def to_miles(km_value)
  #   km_value / 1.6093
  # end
  #

  def average_speed_in_kph
    total_distance_in_km / total_time_in_seconds * 3600
  end

  def xml=(xml_string)
    self[:xml] = xml_string
    calculate_stats
  end

  def south
    points.collect{|point| point.attribute('lat').value.to_f}.max
  end

  def west
    points.collect{|point| point.attribute('lon').value.to_f}.min
  end

  def north
    points.collect{|point| point.attribute('lat').value.to_f}.min
  end

  def east
    points.collect{|point| point.attribute('lon').value.to_f}.max
  end

  def point_coords
    points.collect do |point|
      [point.attribute('lat').value.to_f, point.attribute('lon').value.to_f]
    end
  end

  def start
    DateTime.parse(points.first.at_css('time').content).strftime("%d/%m/%Y") if has_track?
  end

  def has_track?
    @has_track ||= doc.css('trkseg').any?
  end

  private

  def distance_between_points(points)
    lat1 = BigDecimal.new(points[0].attribute('lat').value)
    lat2 = BigDecimal.new(points[1].attribute('lat').value)

    lon1 = BigDecimal.new(points[0].attribute('lon').value)
    lon2 = BigDecimal.new(points[1].attribute('lon').value)
    haversine(lat1, lat2, lon1, lon2)
  end

  def time_between_points(points)
    return 0 unless has_track?
    a, b = points.collect do |point|
      break if point.nil?
      Time.parse(point.css('time').text)
    end
    b - a
  end

  def doc
    @doc ||= Nokogiri::XML(self.xml)
  end

  def points
    @points ||= doc.css('trkpt, rtept')
    @points
  end

  RADIAN_RATIO = Math::PI / 180

  def haversine(lat1, lat2, lon1, lon2)
    earths_radius = 6371.0079; # metres
    φ1 = lat1 * RADIAN_RATIO
    φ2 = lat2 * RADIAN_RATIO
    Δφ = (lat2-lat1) * RADIAN_RATIO
    Δλ = (lon2-lon1) * RADIAN_RATIO

    a = sin(Δφ/2, 5) * sin(Δφ/2, 5) +
            cos(φ1, 5) * cos(φ2, 5) *
            sin(Δλ/2, 5) * sin(Δλ/2, 5);
    c = 2 * Math::atan2(sqrt(a, 16), sqrt(1-a, 16));

    d = earths_radius * c;
  end

  def calc_total_distance_in_km
    total_distance = 0.0
    points.each_cons(2) do |pair|
      total_distance += distance_between_points(pair)
    end
    total_distance
  end


  def calc_total_time_in_seconds
    return 0 if points.empty?
    time_between_points([points.first, points.last])
  end

  def calc_max_speed_in_kph
    max_speed = 0
    points.each_with_index do |point, index|
      break if point.nil? or points[index + 1].nil?
      pair = points[index..index+1]
      speed = (distance_between_points(pair) / time_between_points(pair)) * 3600
      max_speed = speed if max_speed < speed
    end
    max_speed
  end

  def calculate_stats
    self.total_distance_in_km = calc_total_distance_in_km
    self.total_time_in_seconds = calc_total_time_in_seconds
    self.max_speed_in_kph = calc_max_speed_in_kph
  end


end
