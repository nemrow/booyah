class AdminOrdersController < ApplicationController
  def index
    @orders = Order.includes(:picture, :address).order("created_at DESC").all
    @order_count = Order.count
  end

  def show
    @order = Order.find(params[:id])
    @lob_info = @order.get_lob_job_info
  end
end
