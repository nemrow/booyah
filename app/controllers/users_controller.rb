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
    @orders = @user.orders
    order = make_approved_payment(@user, 1.50)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(params[:user])
      redirect_to user_path(user)
    else
      redirect_to edit_user_path(:errors => 'could not update user')
    end
  end
end
