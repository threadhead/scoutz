require 'spec_helper'

describe Scoutlander::Datum::Event do
  before { @event = Scoutlander::Datum::Event.new }
  subject { @event }

  context 'when initialized' do
    specify { expect(subject.name).to be_nil }
    specify { expect(subject.inspected).to be_false }
  end
end
