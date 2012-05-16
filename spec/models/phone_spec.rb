require 'spec_helper'

describe Phone do
  it { should belong_to(:user) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:number) }
end
