# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :picture do
    pdf_source "https://s3.amazonaws.com/booyahbooyah/user_1_1379982196.pdf"
    jpg_source "https://s3.amazonaws.com/booyahbooyah/user_1_1379982196.jpg"
  end
end
