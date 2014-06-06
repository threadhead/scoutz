require 'spec_helper'

RSpec.describe Scoutlander::Importer::Base do
  let(:base) { Scoutlander::Importer::Base.new }

  describe '.find_collection_elements_with' do
    before do
      @adults = []
      @adults << @adult1 = Scoutlander::Datum::Person.new(first_name: 'Rufus', last_name: 'Smith', rank: '1')
      @adults << @adult2 = Scoutlander::Datum::Person.new(first_name: 'Rob', last_name: 'Smith', rank: '2')
      @adults << @adult3 = Scoutlander::Datum::Person.new(first_name: 'Rufus', last_name: 'Smith', rank: '3')
      @adults << @adult4 = Scoutlander::Datum::Person.new(first_name: 'Tom', last_name: 'Thomas', rank: '4')
      base.collection = @adults
    end

    specify { expect(base.find_collection_elements_with(first_name: 'Rob')).to be_a(Array) }
    specify { expect(base.find_collection_elements_with(first_name: 'asdfasdf')).to be_a(Array) }

    context 'with single element finder' do
      specify { expect(base.find_collection_elements_with(first_name: 'Rob')).to include(@adult2) }
      specify { expect(base.find_collection_elements_with(first_name: 'Rob')).to eq([@adult2]) }
      specify { expect(base.find_collection_elements_with(first_name: 'Rob')).not_to include(@adult1) }

      specify { expect(base.find_collection_elements_with(first_name: 'Tom')).to include(@adult4) }
      specify { expect(base.find_collection_elements_with(first_name: 'Tom')).not_to include(@adult1) }

      specify { expect(base.find_collection_elements_with(rank: '3')).to eq([@adult3]) }
      specify { expect(base.find_collection_elements_with(rank: '5')).to eq([]) }
    end

    context 'multiple element finder' do
      specify { expect(base.find_collection_elements_with(first_name: 'Rob', last_name: 'Smith')).to include(@adult2) }
      specify { expect(base.find_collection_elements_with(first_name: 'Rob', last_name: 'Smith')).not_to include(@adult1) }
      specify { expect(base.find_collection_elements_with(first_name: 'Rob', last_name: 'Smith')).not_to include(@adult3) }
      specify { expect(base.find_collection_elements_with(first_name: 'Rob', last_name: 'Smith')).not_to include(@adult4) }
    end

    context 'returns multiple found elements' do
      specify { expect(base.find_collection_elements_with(first_name: 'Rufus', last_name: 'Smith')).to include(@adult1) }
      specify { expect(base.find_collection_elements_with(first_name: 'Rufus', last_name: 'Smith')).to include(@adult3) }
      specify { expect(base.find_collection_elements_with(first_name: 'Rufus', last_name: 'Smith')).not_to include(@adult2) }
      specify { expect(base.find_collection_elements_with(first_name: 'Rufus', last_name: 'Smith')).not_to include(@adult4) }
    end
  end
end
