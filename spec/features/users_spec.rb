require 'spec_helper'

feature "New user signup" do
  scenario "User signs up", :js => true do
    visit root_path
    fill_in 'user[name]', :with => 'Jordan Nemrow'
    fill_in 'user[email]', :with => 'nemrowj@gmail.com'
    fill_in 'user[cell]', :with => '(555) 555-5555'
    fill_in 'user[password]', :with => 'password'
    click_button "Start Printing!"
    page.should have_content("Hello Jordan, you're almost ready to start printing!")

    fill_in "address[name]", :with => 'Grammie and Poppa'
    fill_in "address[address_line1]", :with => '22 Weatherby ct'
    fill_in "address[address_line2]", :with => ''
    fill_in "address[city]", :with => 'Petaluma'
    fill_in "address[state]", :with => 'CA'
    fill_in "address[zip]", :with => '94954'
    fill_in "address[keyword]", :with => 'Grammie'
    click_button "Continue to Paypal"
    # click_button "Log in to your PayPal account"
    # fill_in "login_email", :with => 'jordan@nemrow.com'
    # fill_in "login_password", :with => ENV['PAYPAL_SANDBOX_USER_PASSWORD']
    # click_button "Log In"
    # click_button "Approve"
    # click_button "Return"
    # page.should have_content("Congrats")
  end
end

# WIP more feature tests
# feature "Edit Users Info" do
#   before do
#     @user = FactoryGirl.create(:user)
#     @address = FactoryGirl.create(:grammies_address)
#     @user.addresses << @address
#     @paypal_preapproval = FactoryGirl.create(:paypal_preapproval)
#     @user.paypal_preapprovals << @paypal_preapproval
#   end
#   scenario "Edit address", :js => true do
#     visit root_path
#     click_link 'Sign In'
#     fill_in 'user[email]', :with => @user.email
#     fill_in 'user[password]', :with => @user.password
#     click_button 'Sign In'
#     save_and_open_page
#   end
# end