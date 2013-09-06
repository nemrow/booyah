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
      redirect_to new_user_path(:errors => 'could not create new user')
    end
  end

  def show
    @user = User.find(params[:id])
    @address = @user.address
    @approval_status = check_approval_status(@user)
  end
end
