class OrdersController < ApplicationController
  def index
    p params
    @user = User.find(params[:user_id])
    @orders = @user.orders
  end

  def show
  end
end
