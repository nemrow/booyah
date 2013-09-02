class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    p params
    user = User.find_by_email(params[:user][:email])
    if user.authenticate(params[:user][:password])
      set_current_user(user)
      redirect_to user_path(user)
    else
      # bad login
    end
  end

  def destroy
    remove_current_user
    redirect_to root_path
  end
end
