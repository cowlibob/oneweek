class CacheRouteStats < ActiveRecord::Migration
  def change
    add_column :routes, :total_distance_in_km, :float
    add_column :routes, :total_time_in_seconds, :integer
    add_column :routes, :max_speed_in_kph, :float
  end
end
