class WelcomeController < ApplicationController
  def index
    @user = User.new
  end

  def contact
  end
end
