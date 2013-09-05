require 'spec_helper'

describe Order do
  it { should belong_to(:user) } 
end
