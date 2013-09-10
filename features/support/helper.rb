def sign_in_as_current_user
  visit root_path
  click_link('Sign In')
  fill_in 'user[email]', :with => 'nemrowj@gmail.com'
  fill_in 'user[password]', :with => 'password'
  click_button('Sign In')
end