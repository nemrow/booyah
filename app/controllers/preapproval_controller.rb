class PreapprovalController < ApplicationController
  def show
    preapproval = PaypalPreapproval.find(params[:id])
    preapproval.activate
  end
end
