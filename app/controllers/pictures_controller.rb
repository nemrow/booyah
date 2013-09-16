
class PicturesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    if user = User.find_by_cell(params['msisdn'])
      if user.account_active?
        if params['images'] && params['images'][0]['image']
          image_hash = create_picture(params['images'][0]['image'], user)
          order = create_new_print_order(user, image_hash)
          if order
            send_order_success_sms(order)
          else
            send_failed_order(user)
          end
        else
          send_no_image_response(user)
        end
      else
        send_account_incomplete_message(user)
      end
    else
      send_no_user_message(params['msisdn'])
    end
    render :nothing => true
  end
end
