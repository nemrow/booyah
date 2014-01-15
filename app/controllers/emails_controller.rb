class EmailsController < ApplicationController
  def basic_template
    render :layout => false
  end
end
