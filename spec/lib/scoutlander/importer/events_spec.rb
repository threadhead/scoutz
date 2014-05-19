require 'spec_helper'

describe Scoutlander::Importer::Events do
  describe '.fetch_unit_events' do
    before(:all) do
      @unit = FactoryGirl.create(:unit)
      VCR.use_cassette('fetch_unit_events') do
        @sl = Scoutlander::Importer::Events.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
        @sl.fetch_unit_events
      end
    end
    subject {@sl.events}

    it "does something" do
      puts subject.inspect
    end

    # specify { expect(subject).to_not be_blank }
    # specify { expect(subject.size).to eq(122) }
    # specify { expect(subject.map(&:last_name)).to include("Amann") }
  end

  describe ".sl_time_to_datetime", :focus do
    let(:sl) { Scoutlander::Importer::Events.new }

    specify { expect(sl.sl_time_to_datetime('2014.5.3.7.0.0')).to eq(DateTime.parse('2014-05-03 07:00:00')) }
    specify { expect(sl.sl_time_to_datetime('2014.5.3.7.15.0')).to eq(DateTime.parse('2014-05-03 07:15:00')) }
    specify { expect(sl.sl_time_to_datetime('2014.1.1.0.15.0')).to eq(DateTime.parse('2014-01-01 00:15:00')) }
    specify { expect(sl.sl_time_to_datetime('2014.1.1.23.59.59')).to eq(DateTime.parse('2014-01-01 23:59:59')) }
  end

end
