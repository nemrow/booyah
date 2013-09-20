FactoryGirl.define do
  factory :address do
    address_line1 '22 weatherby ct.'
    address_line2 ''
    city 'Petaluma'
    state 'CA'
    zip '94954'
    country 'US'
    factory :completed_address do
      lob_address_id 'adr_39dd19dac0a5876a'
    end
    factory :grammies_address do
      name 'Grammie and Poppa'
      keyword 'Grammie'
    end
    name 'Jordan Nemrow'
  end
end
