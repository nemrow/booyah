require 'spec_helper'

describe Credit do
  describe "Adding and subtracting credits" do
    before :each do
      @user = FactoryGirl.create(:user)
    end

    it "should add credit to database" do
      expect{
        credit = Credit.create(:amount => 1)
      }.to change(Credit, :count).by(1)
    end

    context "adding the credits to users accounts" do
      before :each do
        5.times do
          credit = Credit.create(:amount => 1)
          @user.credits << credit
        end
        3.times do
          credit = Credit.create(:amount => -1)
          @user.credits << credit
        end
      end

      it 'should add credit to users account' do
        expect(@user.credits.count).to eq(8)
      end

      it "should add up users credits correctly" do
        expect(@user.available_credits).to eq(2)
      end
    end
  end
  it { should belong_to(:user) }
end
