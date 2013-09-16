require 'spec_helper'

describe User do
  context "with valid input" do

    it "should create a new user" do
      expect{
        FactoryGirl.create(:user)
        }.to change(User, :count).by(1)
    end
  end

  context "with invalid name" do
    it "should not create a new user" do
      expect(
        FactoryGirl.build(:user, :name => 'Jordan')
      ).to have(1).errors_on(:name)
    end
  end

  context "with no name" do
    it "should not create a new user" do
      expect(
        FactoryGirl.build(:user, :name => '')
      ).to have(1).errors_on(:name)
    end
  end

  context "with invalid email" do
    it "should not create a new user" do
      expect(
        FactoryGirl.build(:user, :email => 'nemrowj.com')
      ).to have(1).errors_on(:email)
    end
  end

  context "with duplicate email" do
    before do
      FactoryGirl.create(:user, :email => 'nemrowj@gmail.com')
    end
    it "should not create a new user" do
      expect(
        FactoryGirl.build(:user, :email => 'nemrowj@gmail.com')
      ).to have(1).errors_on(:email)
    end
  end

  context "with no email" do
    it "should not create a new user" do
      expect(
        FactoryGirl.build(:user, :email => '')
      ).to have(2).errors_on(:email)
    end
  end

  it { should have_many(:addresses) }
  it { should have_many(:orders) }
  it { should have_many(:paypal_preapprovals) }
end
