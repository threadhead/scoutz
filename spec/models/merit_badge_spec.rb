require 'rails_helper'

RSpec.describe MeritBadge do
  it { is_expected.to have_and_belong_to_many(:users) }


  describe 'validators' do
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
