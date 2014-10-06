require 'rails_vcr_helper'

RSpec.describe Scoutlander::Importer::Adults do
  before(:all) { @unit = FactoryGirl.create(:unit, sl_uid: '3218', unit_type: 'Boy Scouts') }

  describe '.fetch_unit_adults', :vcr do
    before(:all) do
      @sl = Scoutlander::Importer::Adults.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
      VCR.use_cassette('fetch_unit_adults') do
        @sl.fetch_unit_persons(:adult)
      end
    end
    subject { @sl.adults }

    specify { expect(subject).to_not be_blank }
    specify { expect(subject.size).to eq(122) }
    specify { expect(subject.map(&:last_name)).to include("Amann") }
  end


  describe '.fetch_adult_info', :vcr do
    before(:all) do
      @sl = Scoutlander::Importer::Adults.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
      VCR.use_cassette('fetch_adult_info') do
        @sl.fetch_unit_persons(:adult)
        @sl.fetch_person_info(:adult, @sl.adults.first)
        @sl.fetch_person_info(:adult, @sl.adults.last)
        # @sl.adults.each {|a| @sl.fetch_adult_info(a)}
      end
    end
    subject { @sl.adults }

    # specify { expect(subject.first.leadership_position).to eq("Asst Scoutmaster") }
    specify { expect(subject.last.email).to eq("casadezoerb@mac.com") }
  end


  describe '.fetch_adult_info_with_scout_links', :vcr do
    before(:all) do
      @sl = Scoutlander::Importer::Adults.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
      VCR.use_cassette('fetch_adult_info_with_scout_links') do
        @sl.fetch_unit_persons(:adult)
        # pp @sl.adults
        @dave = @sl.find_or_create_by_profile('85542')
        @sl.fetch_adult_info_with_scout_links(@dave)

        @zoerb = @sl.find_or_create_by_profile('284959')
        @sl.fetch_adult_info_with_scout_links(@zoerb)

        @kurt = @sl.find_or_create_by_profile('244779')
        @sl.fetch_adult_info_with_scout_links(@kurt)
      end
    end

    specify { expect(@dave.relations.size).to eq(1) }
    specify { expect(@dave.relations.map(&:sl_profile)).to include("91046") }
    specify { expect(@dave.role).to eq('leader') }

    specify { expect(@zoerb.relations.size).to eq(1) }
    specify { expect(@zoerb.relations.map(&:sl_profile)).to include("284938") }
    specify { expect(@zoerb.role).to eq('basic') }

    specify { expect(@kurt.relations.size).to eq(2) }
    specify { expect(@kurt.relations.map(&:sl_profile)).to include('284941') }
    specify { expect(@kurt.relations.map(&:sl_profile)).to include('284942') }
    specify { expect(@kurt.role).to eq('leader') }
  end


  describe '.find_or_create_by_profile' do
    before do
      @sl = Scoutlander::Importer::Adults.new
      @person1 = Scoutlander::Datum::Person.new(sl_profile: "111")
      @person2 = Scoutlander::Datum::Person.new(sl_profile: "222")
      @person3 = Scoutlander::Datum::Person.new(sl_profile: "333")
      @person2.add_relation(@person3)
      @sl.adults = [@person1, @person2]
    end
    subject { @sl }

    specify { expect(subject.find_or_create_by_profile('111')).to eq(@person1) }
    specify { expect(subject.find_or_create_by_profile('222')).to eq(@person2) }
    specify { expect(subject.find_or_create_by_profile('333')).to eq(@person3) }
  end

end
