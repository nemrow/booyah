class UsersController < ApplicationController
  before_filter :require_login_user, :except => [:new, :create, :forgot_password, :reset_password]

  def new
    @user = User.new
    @error = format_errors(params[:error]) if params[:error]
  end

  def create
    user = User.new(params[:user])
    if user.save
      set_current_user(user)
      user.make_credit_transaction(1, "initial credit")
      redirect_to new_user_address_path(user, :notice => flash("new user basic success", {:user => user}))
    else
      redirect_to new_user_path(:error => user.errors.messages )
    end
  end

  def show
    @notice = params[:notice] if params[:notice]
    @user = User.find(params[:id])
    @addresses = @user.addresses
    @approval_status = PaypalPreapproval.check_approval_status(@user)
    # @preapproval_url = PaypalPreapproval.get_preapproval_url(@user)
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

  def forgot_password
    @error = params[:error] if params[:error]
    @user = User.new
  end

  def reset_password
    user = User.find_by_email(params[:user][:email])
    if user
      temp_password = rand(10000)
      p temp_password
      user.update_attributes(:password => temp_password)
      User.send_sms({:message_code => 11, :cell => user.cell, :user => user, :password => temp_password})
      redirect_to signin_path(:notice => "A new password has been sent to your phone.")
    else
      redirect_to forgot_password_path(:error => "No user with that email")
    end
  end

  def edit_password
    @user = User.find(params[:user_id])
  end

  def update_password
    user = User.find(params[:user_id])
    if user.update_attributes(:password => params[:user][:password])
      redirect_to user_path(user, :notice => "You have successfully changed your password")
    else
      redirect_to change_password_path(user)
    end
  end
end
