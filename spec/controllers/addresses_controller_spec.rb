require 'spec_helper'


describe AddressesController do
  context "User adding an address" do
    before :each do
      @user = FactoryGirl.create(:user)
      session[:user_id] = @user.id
      Address.stub(:verify_address_via_lob).and_return(StubLocker.lob_address_verification_json_return)
      PaypalPreapproval.stub(:get_preapproval_key).and_return('PA-9RF40956PG755650W')
    end

    context "user without a preapproval" do
      before :each do
        post :create, :user_id => @user.id, :address => FactoryGirl.attributes_for(:address)
      end

      it "should add an address to the database" do
        expect(@user.addresses.count).to eq(1)
      end

      it "should redirect to paypal" do
        expect(response).to redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-preapproval&preapprovalkey=PA-9RF40956PG755650W"
      end
    end

    context "user with a preapproval" do
      before :each do
        preapproval = FactoryGirl.create(:paypal_preapproval, :active => true)
        @user.paypal_preapprovals << preapproval
        post :create, :user_id => @user.id, :address => FactoryGirl.attributes_for(:address)
      end

      it "should add an address to the database" do
        expect(@user.addresses.count).to eq(1)
      end

      it "should redirect to users account page" do
        expect(response).to redirect_to user_path(@user)
      end
    end

    context "with an invalid address" do
      before :each do
        post :create, :user_id => @user.id, :address => FactoryGirl.attributes_for(:address, :address_line1 => '')
      end
      it "should redirect back to new_user_address with errors" do
        expect(response).to redirect_to new_user_address_path(@user, :error => 'That address does not exist')
      end
    end

    context "user updating an address" do
      before :each do
        @address = FactoryGirl.create(:address)
        @user.addresses << @address
      end

      context "with valid new address" do
        before :each do
          Address.stub(:verify_address_via_lob).and_return(StubLocker.lob_address_verification_json_return_updated_address)
          put :update, :user_id => @user.id, :id => @address.id, :address => FactoryGirl.attributes_for(:address, :address_line1 => "14 weatherby ct.")
        end
        it "should update the users address" do
          expect(Address.last.address_line1).to eq("14 weatherby ct.")
        end
        it "should redirect to users profile" do
          expect(response).to redirect_to user_path(@user)
        end
      end

      context "with invalid address" do
        before :each do
          Address.stub(:verify_address_via_lob).and_raise(Lob::Error)
          put :update, :user_id => @user.id, :id => @address.id, :address => FactoryGirl.attributes_for(:address, :address_line1 => "9999 weatherby ct.")
        end

        it "should not update the users address" do
          expect(Address.last.address_line1).to eq("22 weatherby ct.")
        end
        it "should redirect to update address with errors" do
          expect(response).to redirect_to edit_user_address_path(@user, @address, :error => 'That address does not exist')
        end
      end
    end
  end
end
  