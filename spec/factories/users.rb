FactoryGirl.define do
  factory :user do
    name "Jordan Nemrow"
    sequence(:email) { |n| "jordan#{n}@nemrow.com"}
    password 'password'
    cell '(707) 849-6085'
  end
end