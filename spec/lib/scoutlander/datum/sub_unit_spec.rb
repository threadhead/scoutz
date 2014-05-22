require 'spec_helper'

describe Scoutlander::Datum::SubUnit do
  let(:sub_unit) { Scoutlander::Datum::SubUnit.new(name: 'Blip') }
  subject { sub_unit }

  context 'when initialized' do
    specify { expect(subject.name).to eq('Blip') }
    specify { expect(subject.inspected).to be_false }
  end

  describe '.to_params' do
    specify { expect(subject.to_params).to eq({name: 'Blip'}) }
    specify { expect(subject.to_params).not_to have_key(:included) }
  end

end
