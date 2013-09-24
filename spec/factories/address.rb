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
      lob_address_id 'adr_7dc743b4b8ab4904'
    end
    name 'Jordan Nemrow'
  end
end
