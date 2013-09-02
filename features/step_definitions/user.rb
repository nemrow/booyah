Given(/^I am not a user$/) do
  User.count.should == 0
end

When(/^I visit the homepage$/) do
  visit root_path
end

Then(/^the page should show 'Welcome to Booyah!'$/) do

end