require 'spec_helper'


describe PicturesController do
  
  describe "receiving incoming MMS from existing user" do

    before :each do
      @user = FactoryGirl.create(:user)
      @address = FactoryGirl.create(:completed_address)
      @paypal_preapproval = FactoryGirl.create(:paypal_preapproval)
      @user.addresses << @address
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
          post :create, StubLocker.valid_order_json
        }.to raise_error("Hello Jordan, your image has been received and you will receive it shortly in the mail! Order total: $1.5.")
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
          post :create, StubLocker.valid_order_json
        }.to raise_error("Hello Jordan, your image has been received and you will receive it shortly in the mail! You used one credit.")
      end
      it "should complete order and deduct a credit from them" do
        PicturesController.any_instance.stub(:send_order_success_with_credits_sms).and_return(true)
        post :create, StubLocker.valid_order_json
        expect(@user.available_credits).to eq(1)
      end
    end 
  end

  describe "Receiving MMS from an unknown number" do
    it "should send back a message stating they are not a member yet" do
      expect{
        post :create, StubLocker.valid_order_json
      }.to raise_error('Hello! This number is not registered with Booyah. Please go to booyahbooyah.com to begin getting prints!')
    end 
  end
end
