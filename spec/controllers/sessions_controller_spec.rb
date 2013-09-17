require 'spec_helper'

describe SessionsController do

  describe "Signing in as an existing user" do
    before :each do
      @user = FactoryGirl.create(:user, :email => 'nemrowj@gmail.com', :password => 'password')
    end

    context "using valid input" do
      it "should sign me in" do
        post :create, :user => {:email => 'nemrowj@gmail.com', :password => 'password'}
        expect(response).to redirect_to user_path(@user)
      end
    end

    context "using invalid email" do
      it "should sign me in" do
        post :create, :user => {:email => 'jordan@gmail.com', :password => 'password'}
        expect(response).to redirect_to signin_path(:error => "No user with that email address")
      end
    end

    context "using invalid password" do
      it "should sign me in" do
        post :create, :user => {:email => 'nemrowj@gmail.com', :password => 'wrongpassword'}
        expect(response).to redirect_to signin_path(:error => "Incorrect Password")
      end
    end
  end
end