When(/^I fill in the following fields for '(.*)':$/) do |model, table|
  table.hashes.each do |row|
    row.each do |key, val|
      fill_in "#{model}[#{key}]", :with => val
    end
  end
end

When(/^I click the '(.*)' button$/) do |value|
  click_button(value)
end

When(/^I click the '(.*)' link$/) do |value|
  click_link(value)
end

When(/^show page$/) do
  save_and_open_page
end

Then(/^the page should show '(.*?)'$/) do |value|
  page.should have_content(value)
end