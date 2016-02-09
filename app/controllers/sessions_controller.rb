class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id unless user.nil?
      redirect_to user, notice: "Welcome back!"
      return
    end
    redirect_to :back, notice: "Username and/or password mismatch"
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end