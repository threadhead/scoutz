require 'rails_helper'

RSpec.describe Scoutlander::Importer::Events do
  before(:all) do
    @unit = FactoryGirl.create(:unit, unit_number: '603', unit_type: 'Boy Scouts', sl_uid: '3218')
    @user = FactoryGirl.create(:adult, first_name: 'Karl', last_name: 'Smith')
    @unit.users << @user
  end

  describe '.fetch_unit_events', :vcr do
    before do
      VCR.use_cassette('fetch_unit_events') do
        @sl = Scoutlander::Importer::Events.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
        @sl.stub(:scrape_months).and_return([Date.new(2013,7,1)])
        @sl.fetch_unit_events
      end
    end
    subject {@sl.events}

    it "does something" do
      # puts subject.inspect
    end

    specify { expect(subject).to_not be_blank }
    specify { expect(subject.first).to be_a(Scoutlander::Datum::Event)}
    specify { expect(subject.size).to eq(7) }
    specify { expect(subject.map(&:name)).to include("Philmont Trek (Troop Event)") }
    specify { expect(subject.map(&:name)).to include("No Troop Meeting (Troop Event)") }
  end


  describe '.fetch_event_info', :vcr do
    before do
      VCR.use_cassette('fetch_event_info') do
        @sl = Scoutlander::Importer::Events.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
        @sl.stub(:scrape_months).and_return([Date.new(2013,7,1)])
        @sl.fetch_unit_events
        # @sl.events.each { |event| @sl.fetch_event_info(event) }
        # @sl.fetch_event_info(@sl.events[5])
        @sl.fetch_all_event_info_and_create
      end
    end
    subject {@sl.events}

    it 'sumptin' do
      # pp subject[5]
    end

  end




  describe ".sl_time_to_datetime" do
    let(:sl) { Scoutlander::Importer::Events.new(unit: @unit) }

    specify { expect(sl.sl_time_to_datetime('2014.5.3.7.0.0')).to eq(DateTime.parse('2014-05-03 07:00:00')) }
    specify { expect(sl.sl_time_to_datetime('2014.5.3.7.15.0')).to eq(DateTime.parse('2014-05-03 07:15:00')) }
    specify { expect(sl.sl_time_to_datetime('2014.1.1.0.15.0')).to eq(DateTime.parse('2014-01-01 00:15:00')) }
    specify { expect(sl.sl_time_to_datetime('2014.1.1.23.59.59')).to eq(DateTime.parse('2014-01-01 23:59:59')) }
  end

end
