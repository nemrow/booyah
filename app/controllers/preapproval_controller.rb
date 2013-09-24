class PreapprovalController < ApplicationController
  def show
    user = User.find(params[:user_id])
    preapproval = PaypalPreapproval.find(params[:id])
    preapproval.activate
    User.send_sms(:user => user, :cell => user.cell, :message_code => 10) if user.addresses.count == 1
  end
end
