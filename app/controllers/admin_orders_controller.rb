class AdminOrdersController < ApplicationController
  def index
    @orders = Order.includes(:picture, :address).order("created_at DESC").all
  end

  def show
    @order = Order.find(params[:id])
  end
end
