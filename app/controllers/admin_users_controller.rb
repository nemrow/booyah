class AdminUsersController < ApplicationController
  before_filter :admin_credentials_required

  def index
    @users = User.all
    @user_count = User.count
    @complete_users = User.all.map{ |user| user.account_active? }.count
  end

  def show
    @error = params[:basic_error] if params[:basic_error]
    @notice = params[:notice] if params[:notice]
    @user = User.find(params[:id])
    @orders = @user.orders.includes(:picture, :address)
    @credit = Credit.new
    @credits = @user.credits
  end
end
