class PreapprovalController < ApplicationController
  def show
    user = User.find(params[:user_id])
    preapproval = PaypalPreapproval.find(params[:id])
    preapproval.activate
    # send_welcome_message(user) if user.addresses.count == 1
  end
end
