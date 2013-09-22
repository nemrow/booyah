class PicturesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    if user = User.verify_sender_status_by_cell(params)
      if receiver = user.verify_receiver(user, params)
        if image_hash = verify_image(params, user)
          credits = user.available_credits
          order = create_new_print_order(user, image_hash, receiver) 
          if credits < 1
            order ? send_order_success_sms(order, receiver) : send_paypal_failed_message(user)
          else
            order ? send_order_success_with_credits_sms(order, receiver) : send_failed_order(user)      
          end
        end
      end
    end
    render :json => {}
  end
end
