require 'rails_helper'

RSpec.describe Scoutlander::Datum::Person do
  let(:person) { Scoutlander::Datum::Person.new(email: 'threadhead@gmail.com') }
  subject { person }

  context 'when initialized' do
    specify { expect(subject.parent).to be_nil }
    specify { expect(subject.email).to eq('threadhead@gmail.com') }
    specify { expect(subject.relations).to be_empty }
    specify { expect(subject.parent).to be_nil }
    specify { expect(subject.inspected).to be_falsy }
  end

  describe '.add_relation' do
    before do
      @person2 = Scoutlander::Datum::Person.new
      person.add_relation(@person2)
    end

    specify { expect(subject.relations.size).to eq(1) }
    specify { expect(subject.relations).to include(@person2) }
    specify { expect(@person2.parent).to eq(person) }

    it 'should reject non-Person objects' do
      @person3 = Hash.new
      person.add_relation(@person3)
      expect(subject.relations).to_not include(@person3)
    end
  end

  describe '.to_params' do
    specify { expect(subject.to_params).to include({ email: 'threadhead@gmail.com' }) }
    specify { expect(subject.to_params).not_to have_key(:included) }
    specify { expect(subject.to_params).not_to have_key(:relations) }
    specify { expect(subject.to_params).not_to have_key(:parent) }
    specify { expect(subject.to_params).not_to have_key(:security_level) }
  end

end
