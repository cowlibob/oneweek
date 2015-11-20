class RoutesController < ApplicationController
  def index
    @routes = Route.where(user_id: session[:user_id]).all
  end

  def new
    @route = Route.new
  end

  def create
    @route = Route.new(user_id: session[:user_id], name: route_params[:name], xml: route_params[:xml].read)
    if @route.save
      flash[:notice] = "Successfully uploaded new route."
      redirect_to action: :index
    else
      flash[:error] = @route.errors.full_messages.join('<br/>')
      render :new
    end
  end

  def show
    @route = Route.find(params[:id])
  end

  def destroy
    @route = Route.find(params[:id])
    if @route
      @route.destroy
      flash[:notice] = "Successfully deleted the route."
      redirect_to routes_path
    end
  end


  private

  def route_params
    params.require(:route).permit(:name, :xml)
  end
end
