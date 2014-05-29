require 'spec_helper'

describe Phone do
  it { should belong_to(:user) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:number) }
  it { should validate_uniqueness_of(:kind).scoped_to(:user_id) }
  it { should validate_uniqueness_of(:number).scoped_to(:user_id) }
end
