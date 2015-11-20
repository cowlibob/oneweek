class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    if auth
      flash[:notice] = "Welcome, #{auth.info.nickname}"
      session[:user_id] = auth.uid
    else
      flash[:error] = "Sorry, we could not log you in."
      session[:user_id] = nil
    end
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to :back
  end
end
