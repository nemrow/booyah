class PicturesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    Order.handle_incoming_message(params)
    render :nothing => true
  end
end
