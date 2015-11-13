class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    if auth
      flash[:notice] = "Welcome, #{auth.info.nickname}"
      session[:user] = auth.uid
    else
      flash[:error] = "Sorry, we could not log you in."
      session[:user] = nil
    end
    redirect_to root_url
  end

  def destroy
    session[:user] = nil
    redirect_to :back
  end
end
