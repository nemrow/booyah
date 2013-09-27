class WelcomeController < ApplicationController
  def index
    @user = User.new
  end

  def contact
    p send_basic_email(
      'nemrowj@gmail.com',
      'this is a subjeezy',
      'Jordannn',
      [
        "p num 1",
        "p num 2",
        "p num 3"
      ]
    )
  end
end
