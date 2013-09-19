require 'spec_helper'

describe UsersController do
  
  context "POST create" do

    it "should create a new user when accurate data is input" do
      expect{
        post :create, :user => FactoryGirl.attributes_for(:user)
      }.to change(User, :count).by(1)
    end

    it "should give add a Credit to the database" do
      expect{
        post :create, :user => FactoryGirl.attributes_for(:user)
      }.to change(Credit, :count).by(1)
    end

    it "should assign that credit to the user" do
        post :create, :user => FactoryGirl.attributes_for(:user)
        expect(User.last.available_credits).to eq(1)
    end

    it "should not create a new user without last name" do
      expect{
        post :create, :user => FactoryGirl.attributes_for(:user, :name => 'Jordan')
      }.to_not change(User, :count)
    end

    it "should not create a new user without name" do
      expect{
        post :create, :user => FactoryGirl.attributes_for(:user, :name => nil)
      }.to_not change(User, :count)
    end 

    it "should not create a new user without cell" do
      expect{
        post :create, :user => FactoryGirl.attributes_for(:user, :cell => nil)
      }.to_not change(User, :count)
    end 

     it "should not create a new user with invalid cell (non-digit)" do
      expect{
        post :create, :user => FactoryGirl.attributes_for(:user, :cell => '555555666t')
      }.to_not change(User, :count)
    end 

    it "should not create a new user with invalid cell (incorrect length)" do
      expect{
        post :create, :user => FactoryGirl.attributes_for(:user, :cell => '555555666')
      }.to_not change(User, :count)
    end

    it "should not create a new user with invalid email" do
      expect{
        post :create, :user => FactoryGirl.attributes_for(:user, :email => 'nemrowj.com')
      }.to_not change(User, :count)
    end
  end
end