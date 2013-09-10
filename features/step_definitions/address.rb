Given(/^I have step one of the signup complete \(basic user info\)$/) do
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