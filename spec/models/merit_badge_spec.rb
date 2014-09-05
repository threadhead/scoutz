require 'rails_helper'

RSpec.describe MeritBadge do
  it { is_expected.to have_many(:users).through(:counselors) }
  it { is_expected.to have_many(:counselors) }


  describe 'validators' do
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
