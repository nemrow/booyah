require 'spec_helper'

describe PicturesController do
  
  context "receiving incoming MMS from an existing user with accurate data" do

    before do
      @user = FactoryGirl.create(:user)
      @address = FactoryGirl.create(:address)
      @paypal_preapproval = FactoryGirl.create(:paypal_preapproval)
      @user.addresses << @address
      @user.paypal_preapprovals << @paypal_preapproval
      @paypal_preapproval.activate
    end

    it "should get the data" do
      json = JSON.parse(' {
                            "event": "message-in",
                            "campaign_id": "49136",
                            "msisdn": "17078496085",
                            "carrier": "Verizon Wireless",
                            "message": "Booyah",
                            "subject": "",
                            "images": [
                              {
                                "image": "http://d2c.bandcon.mogreet.com/mo-mms/images/710133_4856324.jpeg"
                              }
                            ]
                          }
                        ')
      post :create, json
      response.status. should == 200
      @user.orders.count.should == 1
    end 
  end
end

# lanscape
# http://d2c.bandcon.mogreet.com/mo-mms/images/710133_4856324.jpeg

# vertical
# http://d2c.bandcon.mogreet.com/mo-mms/images/710148_4856428.jpeg
