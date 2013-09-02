class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(params[:user])
    if user.save
      set_current_user(user)
      redirect_to new_user_address_path(user)
    else

    end
  end

  def show
    @user = User.find(params[:id])
    @addresses = @user.addresses
  end
end
