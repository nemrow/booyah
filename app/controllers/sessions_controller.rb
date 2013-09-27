class SessionsController < ApplicationController
  def new
    @user = User.new
    @error = format_plain_error(params[:error]) if params[:error]
    @notice = params[:notice] if params[:notice]
  end

  def create
    user = User.find_by_email(params[:user][:email])
    return redirect_to signin_path(:error => "No user with that email address") if user == nil
    if user.authenticate(params[:user][:password])
      set_current_user(user)
      redirect_to user_path(user)
    else
      redirect_to signin_path(:error => "Incorrect Password")
    end
  end

  def destroy
    remove_current_user
    redirect_to root_path
  end
end
