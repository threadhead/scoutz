require 'spec_helper'

RSpec.describe Scoutlander::Datum::Event do
  let(:event) { Scoutlander::Datum::Event.new(attire: 'none') }
  subject { event }

  context 'when initialized' do
    specify { expect(subject.name).to be_nil }
    specify { expect(subject.attire).to eq('none') }
    specify { expect(subject.inspected).to be_falsy }
  end

  describe '.to_params' do
    specify { expect(subject.to_params).to eq({attire: 'none'}) }
    specify { expect(subject.to_params).not_to have_key(:included) }
    specify { expect(subject.to_params).not_to have_key(:kind_sub_units) }
  end

end
