# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    to_id { "adr_39dd19dac0a5876a" }
    lob_order_id { "job_1090046c4d77d278" } 
    pdf_source { "https://s3.amazonaws.com/booyahbooyah/user_52_13790" }
    jpg_source { "https://s3.amazonaws.com/booyahbooyah/user_52_13790" }
    lob_cost { 1.21 }
    user_cost { 1.5 }
    lob_object_id { "obj_8f939617219ad8e" }
  end
end
