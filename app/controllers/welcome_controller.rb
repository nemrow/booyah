class WelcomeController < ApplicationController
  def index
    write_to_aws
  end
end
