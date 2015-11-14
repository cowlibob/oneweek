class RoutesController < ApplicationController
  def index
    @routes = Route.all
  end

  def new
    @route = Route.new
  end

  def create
    @route = Route.new(name: route_params[:name], xml: route_params[:xml].read)
    if @route.save
      flash[:notice] = "Successfully uploaded new route."
      redirect_to action: :index
    else
      flash[:error] = @route.errors.full_messages.join('<br/>')
      render :new
    end
  end

  private

  def route_params
    params.require(:route).permit(:name, :xml)
  end
end
