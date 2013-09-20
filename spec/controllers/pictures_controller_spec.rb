require 'spec_helper'


describe PicturesController do
  
  describe "receiving incoming MMS from existing user" do

    before :each do
      @user = FactoryGirl.create(:user)
      @address = FactoryGirl.create(:completed_address)
      @user.addresses << @address
      @address.update_attributes(:default => true)
      @paypal_preapproval = FactoryGirl.create(:paypal_preapproval)
      @user.paypal_preapprovals << @paypal_preapproval
      @paypal_preapproval.activate
      @order = FactoryGirl.create(:order)
      @paypal_payment = PaypalPayment.create(:transaction_id => '3YV02934GD864243A', :status => 'COMPLETED')
      @user.orders << @order
      PicturesController.any_instance.stub(:create_picture).and_return(StubLocker.create_picture_json)
      PicturesController.any_instance.stub(:order_new_print).and_return(StubLocker.lob_order_return)
      PicturesController.any_instance.stub(:make_approved_payment).and_return(@paypal_payment)
    end

    context "with accurate data" do
      it "should create an order and send confirmation message" do
        expect{
          post :create, StubLocker.valid_order_json_no_receiver
        }.to raise_error("Hello Jordan, your image has been received and it will be shipped to Jordan Nemrow shortly! Order total: $1.5.")
      end 
    end

    context "without image" do
      it "should reply to user letting them know no image was attatched" do
        expect{
          post :create, StubLocker.no_image_order_json
        }.to raise_error('Hello Jordan, It appears there was no image attached to that message!')
      end 
    end

    context "with accurate data and available credits" do
      before :each do
        credit = Credit.create(:amount => 2)
        @user.credits << credit
      end
      it "should complete order and send them credit deduction confirmation" do
        expect{
          post :create, StubLocker.valid_order_json_no_receiver
        }.to raise_error("Hello Jordan, your image has been received and it will be shipped to Jordan Nemrow shortly! You used one credit.")
      end
      it "should complete order and deduct a credit from them" do
        PicturesController.any_instance.stub(:send_order_success_with_credits_sms).and_return(true)
        post :create, StubLocker.valid_order_json_no_receiver
        expect(@user.available_credits).to eq(1)
      end
    end

    context "not specifying a receiver and not having a default address" do
      before :each do
        @address.update_attributes(:default => false)
      end
      it "should send a unrecognizable receiver message" do
        expect{
          post :create, StubLocker.valid_order_json_no_receiver
        }.to raise_error("Hello Jordan, We are sorry, we could not recognize the receiver for this picture! Reply with 'people' to get a list.")
      end
    end

    context "specifying a receiver that is not in users contacts" do
      before :each do
        @address.update_attributes(:default => false)
      end
      it "should send a unrecognizable receiver message" do
        expect{
          post :create, StubLocker.valid_order_with_receiver_json
        }.to raise_error("Hello Jordan, We are sorry, we could not recognize the receiver for this picture! Reply with 'people' to get a list.")
      end
    end

    context "specifying a receiver that is in your contacts" do
      before :each do
        grammie_address = FactoryGirl.create(:grammies_address)
        @user.addresses << grammie_address
      end
      context "by specifying keyword" do
        it "should create an order and send confirmation message" do
          expect{
            post :create, StubLocker.valid_order_with_receiver_json
          }.to raise_error("Hello Jordan, your image has been received and it will be shipped to Grammie And Poppa shortly! Order total: $1.5.")
        end
      end
      context "by specifying name" do
        it "should create an order and send confirmation message" do
          expect{
            post :create, StubLocker.valid_order_with_receiver_name_json
          }.to raise_error("Hello Jordan, your image has been received and it will be shipped to Grammie And Poppa shortly! Order total: $1.5.")
        end
      end
    end

    context "requesting contacts" do
      it "should send back a list of their contacts" do
        expect{
          post :create, StubLocker.contacts_request_json
        }.to raise_error("Hello Jordan, Here is the list of contacts: we have not developed this yet")
      end
    end
  end

  describe "Receiving MMS from an unknown number" do
    it "should send back a message stating they are not a member yet" do
      expect{
        post :create, StubLocker.valid_order_json_no_receiver
      }.to raise_error('Hello! This number is not registered with Booyah. Please go to booyahbooyah.com to begin getting prints!')
    end 
  end
end
