include OrdersHelper

class PicturesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    user = User.find_by_cell(params['msisdn'])
    if params['images'][0]['image']
      new_picture_url = create_picture(params['images'][0]['image'], user)
      order = create_new_order(user, new_picture_url)
      if order
        send_order_success_sms(order)
      else
        send_failed_order(user)
      end
    else
      send_no_image_response(user)
    end
    render :nothing => true
  end
end
