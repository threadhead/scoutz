require 'rails_helper'

RSpec.describe Scoutlander::Datum::Unit do
  let(:unit) { Scoutlander::Datum::Unit.new(state: 'AZ') }
  subject { unit }

  context 'when initialized' do
    specify { expect(subject.name).to be_nil }
    specify { expect(subject.state).to eq('AZ') }
    specify { expect(subject.inspected).to be_falsy }
  end

  describe '.to_params' do
    specify { expect(subject.to_params).to eq({ state: 'AZ' }) }
    specify { expect(subject.to_params).not_to have_key(:included) }
  end
end
