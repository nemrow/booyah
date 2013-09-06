# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :paypal_preaproval, :class => 'PaypalPreaprovals' do
    key "MyString"
    user_id 1
    active false
  end
end
