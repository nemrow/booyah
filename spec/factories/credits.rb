# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit do
    user_id 1
    amount 1
    description "MyString"
  end
end
