require 'spec_helper'

describe Scoutlander::Datum::Person do
  before { @person = Scoutlander::Datum::Person.new }
  subject {@person}

  context 'when initialized' do
    specify { expect(subject.parent).to be_nil }
    specify { expect(subject.relations).to be_empty }
    specify { expect(subject.inspected).to be_false }
  end

  describe '.add_relation' do
    before do
      @person2 = Scoutlander::Datum::Person.new
      @person.add_relation(@person2)
    end

    specify { expect(subject.relations.size).to eq(1) }
    specify { expect(subject.relations).to include(@person2) }
    specify { expect(@person2.parent).to eq(@person) }

    it 'should reject non-Person objects' do
      @person3 = Hash.new
      @person.add_relation(@person3)
      expect(subject.relations).to_not include(@person3)
    end
  end
end
