# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    to_id "MyString"
    user_id 1
    lob_order_id "MyString"
  end
end
