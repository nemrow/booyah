
class PicturesController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    user = User.find_by_cell(params['msisdn'])
    return send_no_user_message(params['msisdn']) if user == nil
    return send_account_incomplete_message(user) if !user.account_active?
    receiver = user.get_receiver(params['message'])
    p receiver
    return send_contact_list_message(user) if receiver == 'people'
    return send_could_not_recognize_receiver_message(user) if !receiver
    return send_no_image_response(user) if !params['images'] && receiver != 'people'
    begin
      image_hash = create_picture(params['images'][0]['image'], user)
    rescue
      return send_failed_order(user)
    end
    credits = user.available_credits
    order = create_new_print_order(user, image_hash, receiver) 
    if credits < 1
      order ? send_order_success_sms(order, receiver) : send_paypal_failed_message(user)
    else
      order ? send_order_success_with_credits_sms(order, receiver) : send_failed_order(user)      
    end
    render :json => {}
  end
end
