require 'spec_helper'

describe Scoutlander::Importer::Units do
  describe '.available_names_uids', :vcr do
    before(:all) do
      VCR.use_cassette('available_names_uids') do
        @sl = Scoutlander::Importer::Units.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'])
        @sl.available_names_uids
      end
    end

    subject {@sl.units}

    specify { expect(subject.size).to eq(2) }
    specify { expect(subject.first).to be_kind_of(Scoutlander::Datum::Unit) }
    specify { expect(subject.map(&:name)).to include("BS Troop 603 Website (Cave Creek, Arizona)") }
    specify { expect(subject.map(&:name)).to include("CS Pack 134 Website (Cave Creek, Arizona)") }
  end


  describe '.split_city_state' do
    before(:all) { @sl = Scoutlander::Importer::Units.new }

    it 'Chicago, IL' do
      city, state = @sl.split_city_state('Chicago, IL')
      expect(city).to eq("Chicago")
      expect(state).to eq("IL")
    end

    it 'San Diego, CA' do
      city, state = @sl.split_city_state('San Diego, CA')
      expect(city).to eq("San Diego")
      expect(state).to eq("CA")
    end
  end
end
