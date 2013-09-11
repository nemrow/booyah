Given(/^I have step one of the signup complete \(basic user info\)$/) do
  AddressesController.any_instance.should_receive(:get_preapproval_url)
    .and_return(root_path)

  address_verify = '{
    "address":  {
      "address_line1": "22 WEATHERBY CT", 
      "address_line2": "", 
      "address_city": "PETALUMA", 
      "address_state": "CA", 
      "address_zip": "94954-4659", 
      "address_country": "US", 
      "object": "address"
    }
  }'
  lob_address_create = '{
    "id": "adr_500095d2249adbc2", 
    "name": "Jordan Nemrow", 
    "email": "lhjs@ljhd.co", 
    "phone": "17078886666", 
    "address_line1": "22 weatherby ct", 
    "address_line2": "", 
    "address_city": "petaluma", 
    "address_state": "Ca", 
    "address_zip": "94954", 
    "address_country": "US", 
    "date_created": "2013-09-10T20:44:23+00:00", 
    "date_modified": "2013-09-10T20:44:23+00:00", 
    "object": "address"
  }'

  preapproval_key = '{
    "timestamp": "Tue, 10 Sep 2013 14:06:31 -0700",
    "ack": "Success",
    "correlationId": "5994cc330e25d",
    "build": "6941298", 
    "preapprovalKey": "PA-7EG71704DU473484V"
  }'

  FakeWeb.register_uri(:post, "https://svcs.sandbox.paypal.com/AdaptivePayments/Preapproval", :body => preapproval_key, :code => '200')
  FakeWeb.register_uri(:post, "https://test_1b18043ff9bdf8042529d52989aeed03e6b@api.lob.com/v1/verify", :body => address_verify)
  FakeWeb.register_uri(:post, "https://test_1b18043ff9bdf8042529d52989aeed03e6b@api.lob.com/v1/addresses", :body => lob_address_create)

  sign_in_as_current_user
  User.count.should == 1
  User.last.address.should == nil
end

Given(/^I am on the new address page$/) do
  click_link('Add your address')
end

Then(/^I should have an address attatched to my account$/) do
  User.last.address.should_not == nil
end