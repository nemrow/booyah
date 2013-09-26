class Credit < ActiveRecord::Base
  attr_accessible :amount, :description, :user_id

  belongs_to :user

  validates :amount, :numericality => true
end
