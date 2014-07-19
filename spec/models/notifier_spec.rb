require 'rails_helper'

RSpec.describe Notifier do
  it { should belong_to(:user) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:account) }
end
