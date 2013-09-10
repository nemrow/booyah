Before('@user_with_basic_info') do
  @user = User.create(
    :email => 'nemrowj@gmail.com',
    :name => 'Jordan Nemrow',
    :cell => '7078496085',
    :password => 'password'
  )
end