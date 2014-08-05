require 'rails_helper'

RSpec.describe Page do
  let(:page) { FactoryGirl.build(:page) }

  it { is_expected.to belong_to(:created_by) }
  it { is_expected.to belong_to(:unit) }

  it { expect(page).to be_valid }

  describe 'validators' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to ensure_length_of(:title).is_at_least(1).is_at_most(48) }
    it { is_expected.to validate_presence_of(:body) }
  end

  it 'sanitizes the body on save' do
    expect(Sanitize).to receive(:clean)
    page.save
  end
end
