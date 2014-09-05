require 'rails_helper'

RSpec.describe UnitPosition, :type => :model do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:unit_id) }
end
