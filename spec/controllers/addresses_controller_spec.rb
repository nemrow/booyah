require 'spec_helper'


describe AddressesController do
  context "User adding an address" do
    before :each do
      @user = FactoryGirl.create(:user)
      session[:user_id] = @user.id
      AddressesController.any_instance.stub(:verify_address_via_lob).and_return(StubLocker.lob_address_verification_json_return)
      AddressesController.any_instance.stub(:get_preapproval_key).and_return('PA-9RF40956PG755650W')
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
  end
end
  