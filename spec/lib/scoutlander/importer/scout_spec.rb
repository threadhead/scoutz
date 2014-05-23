require 'spec_helper'

describe Scoutlander::Importer::Scouts do
  before(:all) { @unit = FactoryGirl.create(:unit, sl_uid: '3218', unit_type: 'Boy Scouts') }

  describe '.fetch_unit_scouts', :vcr do
    before(:all) do
      @sl = Scoutlander::Importer::Scouts.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
      VCR.use_cassette('fetch_unit_scouts') do
        @sl.fetch_unit_scouts
      end
    end
    subject { @sl.scouts }

    it "does something" do
      ap subject
    end

    # specify { expect(subject).to_not be_blank }
    # specify { expect(subject.size).to eq(122) }
    # specify { expect(subject.map(&:last_name)).to include("Amann") }
  end


  describe '.fetch_scout_info', :vcr do
    before(:all) do
      @sl = Scoutlander::Importer::Scouts.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
      VCR.use_cassette('fetch_scout_info') do
        @sl.fetch_unit_scouts
        @sl.fetch_scout_info(@sl.scouts.first)
        @sl.fetch_scout_info(@sl.scouts[1])
        @sl.fetch_scout_info(@sl.scouts.last)
        @sl.scouts.each {|s| @sl.fetch_scout_info(s)}
      end
    end
    subject { @sl.scouts }

    it "does something", :focus do
      pp @sl.scouts.first
      pp @sl.scouts.last
      pp @sl.scouts[1]
    end

    # specify { expect(subject.first.leadership_position).to eq("Asst Scoutmaster") }
    # specify { expect(subject.last.email).to eq("casadezoerb@mac.com") }
  end


end
