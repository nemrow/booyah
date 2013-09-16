class UsersController < ApplicationController
  def new
    @user = User.new
    @error = format_errors(params[:error]) if params[:error]
  end

  def create
    user = User.new(params[:user])
    if user.save
      set_current_user(user)
      redirect_to new_user_address_path(user, :notice => flash("new user basic success", {:user => user}))
    else
      redirect_to new_user_path(:error => user.errors.messages )
    end
  end

  def show
    @user = User.find(params[:id])
    @address = @user.address
    @approval_status = check_approval_status(@user)
    @orders = @user.orders
  end

  def edit
    @error = params[:error] if params[:error]
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(params[:user])
      redirect_to user_path(user)
    else
      redirect_to edit_user_path(:error => 'could not update user')
    end
  end
end
