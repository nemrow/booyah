include OrdersHelper

class PicturesController < ApplicationController
  def create
    user = User.find_by_cell(params['msisdn'])
    new_picture_url = create_picture(params['images'][0]['image'], user)
    if create_new_order(user, new_picture_url)
      p "it worked"
    else
      p "it failed"
    end
    render :nothing => true
  end
end
