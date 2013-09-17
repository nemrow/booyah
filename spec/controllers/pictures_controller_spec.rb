require 'spec_helper'


describe PicturesController do
  
  describe "receiving incoming MMS from existing user" do

    before :each do
      @user = FactoryGirl.create(:user)
      @address = FactoryGirl.create(:address)
      @paypal_preapproval = FactoryGirl.create(:paypal_preapproval)
      @user.addresses << @address
      @user.paypal_preapprovals << @paypal_preapproval
      @paypal_preapproval.activate
      @order = FactoryGirl.create(:order)
      @user.orders << @order
      PicturesController.any_instance.stub(:create_picture).and_return({:pdf=>"https://s3.amazonaws.com/booyahbooyah/user_52_1379099369.pdf", :jpg=>"https://s3.amazonaws.com/booyahbooyah/user_52_1379099369.jpg"})
      PicturesController.any_instance.stub(:create_new_print_order).and_return(@order)
      @valid_order_json = JSON.parse( 
        '{
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
        }'
      )
      @no_image_order_json = JSON.parse( 
        '{
          "event": "message-in",
          "campaign_id": "49136",
          "msisdn": "17078496085",
          "carrier": "Verizon Wireless",
          "message": "Booyah",
          "subject": ""
        }'
      )
    end

    context "with accurate data" do
      it "should create an order and send confirmation message" do
        expect{
          post :create, @valid_order_json
        }.to raise_error("Hello Jordan, your image has been received and you will receive it shortly in the mail! Order total: $1.5.")
      end 
    end

    context "without image" do
      it "should reply to user letting them know no image was attatched" do
        expect{
          post :create, @no_image_order_json
        }.to raise_error('Hello Jordan, It appears there was no image attached to that message!')
      end 
    end
  end

  describe "Receiving MMS from an unknown number" do
    it "should send back a message stating they are not a member yet" do
      expect{
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
      }.to raise_error('Hello! This number is not registered with Booyah. Please go to booyahbooyah.com to begin getting prints!')
    end 
  end
end

# lanscape
# http://d2c.bandcon.mogreet.com/mo-mms/images/710133_4856324.jpeg

# vertical
# http://d2c.bandcon.mogreet.com/mo-mms/images/710148_4856428.jpeg
