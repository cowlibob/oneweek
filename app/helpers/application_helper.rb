module ApplicationHelper
  def current_user
    session[:user_id]
  end

  def display_time(total_seconds)
    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60)

    if hours > 0
      format("%dh %dm %ds", hours, minutes, seconds) #=> "01:00:00"
    else
      format("%dm %ds", minutes, seconds) #=> "01:00:00"
    end
  end
end
