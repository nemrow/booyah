# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :paypal_payment do
    status "MyString"
    amount "9.99"
    transaction_id "MyString"
    order_id "MyString"
  end
end
