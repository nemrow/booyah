require 'spec_helper'

describe PicturesController do
  
  context "receiving incoming MMS from an existing user" do

    before do
      @user = FactoryGirl.create(:user)
      @address = FactoryGirl.create(:address)
      @user.addresses << @address
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
                                "image": "http://d2c.bandcon.mogreet.com/mo-mms/images/695364_4767994.jpeg"
                              }
                            ]
                          }
                        ')
      post :create, json
      # Application.count.should == 0
      # response.status.should eq(403)
      # JSON.parse(response.body)["status"] == "error"
      # JSON.parse(response.body)["message"] =~ /authorized/
    end 
  end
end
