require 'spec_helper'

describe Notifier do
  it { should belong_to(:user) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:account) }
end
