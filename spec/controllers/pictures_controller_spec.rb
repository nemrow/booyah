require 'spec_helper'


describe PicturesController do
  
  describe "receiving incoming MMS from existing user" do

    context "with existing users data" do

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
        @picture = FactoryGirl.create(:picture)
      end
      
      context "with outside url's stubbed" do

        before :each do
          Picture.stub(:create_picture).and_return(StubLocker.create_picture_json)
          Order.stub(:order_new_print).and_return(StubLocker.lob_order_return)
          PaypalPayment.stub(:make_approved_payment).and_return(@paypal_payment)
          User.stub(:make_mogreet_request).and_return(true)
        end

        context "with accurate data" do
          it "should create an order and send confirmation message" do
            User.should receive(:send_sms).with(hash_including(:message_code => 1))
            post :create, StubLocker.valid_order_json_no_receiver
          end 
        end

        context "without image" do
          it "should reply to user letting them know no image was attatched" do
            User.should receive(:send_sms).with(hash_including(:message_code => 9))
            post :create, StubLocker.no_image_order_json
          end 
        end

        context "with accurate data and available credits" do
          before :each do
            credit = Credit.create(:amount => 2)
            @user.credits << credit
          end
          it "should complete order and send them credit deduction confirmation" do
            User.should receive(:send_sms).with(hash_including(:message_code => 5))
            post :create, StubLocker.valid_order_json_no_receiver
          end
          it "should complete order and deduct a credit from them" do
            post :create, StubLocker.valid_order_json_no_receiver
            expect(@user.available_credits).to eq(1)
          end
        end

        context "not specifying a receiver and not having a default address" do
          before :each do
            @address.update_attributes(:default => false)
          end
          it "should send a unrecognizable receiver message" do
            User.should receive(:send_sms).with(hash_including(:message_code => 4))
            post :create, StubLocker.valid_order_json_no_receiver
          end
        end

        context "specifying a receiver that is not in users contacts" do
          before :each do
            @address.update_attributes(:default => false)
          end
          it "should send a unrecognizable receiver message" do
            User.should receive(:send_sms).with(hash_including(:message_code => 4))
            post :create, StubLocker.valid_order_with_receiver_json
          end
        end

        context "specifying a receiver that is in your contacts" do
          before :each do
            grammie_address = FactoryGirl.create(:grammies_address)
            @user.addresses << grammie_address
          end
          context "by specifying keyword" do
            it "should create an order and send confirmation message" do
              User.should receive(:send_sms).with(hash_including(:message_code => 1))
              post :create, StubLocker.valid_order_with_receiver_json
            end
          end
          context "by specifying name" do
            it "should create an order and send confirmation message" do
              User.should receive(:send_sms).with(hash_including(:message_code => 1))
              post :create, StubLocker.valid_order_with_receiver_name_json
            end
          end
        end

        context "If an error occurs ordering from Lob" do
          before :each do
            Order.stub(:order_new_print).and_return(false)
          end

          it "should refund the paypal account and send an error sms" do
            User.should receive(:send_sms).with(hash_including(:message_code => 12))
            post :create, StubLocker.valid_order_json_no_receiver
          end 
        end

        context "requesting contacts" do
          before :each do
            @user.addresses << FactoryGirl.create(:completed_address, :name => 'BB Nems')
            @user.addresses << FactoryGirl.create(:completed_address, :name => 'Dad')
            @address.update_attributes(:default => false)
          end
          it "should send back a list of their contacts" do
            User.should receive(:send_sms).with(hash_including(:message_code => 3))
            post :create, StubLocker.contacts_request_json
          end
        end

        describe "Receiving MMS from an unknown number" do
          it "should send back a message stating they are not a member yet" do
            User.should receive(:send_sms).with(hash_including(:message_code => 8))
            post :create, StubLocker.valid_order_json_unkown_cell
          end 
        end
      end
      
      # context "with accurate data" do
      #   it "should create an order and send confirmation message" do
      #     User.should receive(:send_sms).with(hash_including(:message_code => 1))
      #     post :create, StubLocker.valid_order_json_no_receiver
      #   end 
      # end
    end
  end
end
