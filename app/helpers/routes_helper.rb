module RoutesHelper

  def use_miles?
    cookies[:units] == 'miles'
  end

  def speed_unit
    if use_miles?
      "mph"
    else
      "kph"
    end
  end

  def distance_unit
    if use_miles?
      "miles"
    else
      "km"
    end
  end

  def distance(value)
    if use_miles?
      (value / 1.6093).round(2)
    else
      value
    end
  end

  def speed(value)
    distance(value)
  end
end
