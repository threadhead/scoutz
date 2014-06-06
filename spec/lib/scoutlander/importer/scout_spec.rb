require 'spec_helper'

RSpec.describe Scoutlander::Importer::Scouts do
  before(:all) { @unit = FactoryGirl.create(:unit, sl_uid: '3218', unit_type: 'Boy Scouts') }

  describe '.fetch_unit_persons', :vcr do
    before(:all) do
      @sl = Scoutlander::Importer::Scouts.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
      VCR.use_cassette('fetch_unit_scouts') do
        @sl.fetch_unit_persons(:scout)
      end
    end

    subject { (@sl.find_collection_elements_with first_name: 'Bennett', last_name: 'Smith').first }



    specify { expect(subject).to_not be_blank }

    context 'loaded attributes' do
      specify { expect(subject.sl_profile).to eq('493321') }
      specify { expect(subject.sl_uid).to eq('3218') }
      specify { expect(subject.sl_url).not_to be_blank }
    end

    context 'unloaded attributes' do
      [ :sub_unit, :leadership_position, :additional_leadership_positions, :security_level, :email, :alternate_email, :send_reminders, :home_phone, :work_phone, :cell_phone, :address1, :city, :state, :zip_code, :rank].each do |attr|
        specify { expect(subject.send(attr)).to be_nil }
      end
    end
  end




  describe '.fetch_scout_info', :vcr do
    before(:all) do
      @sl = Scoutlander::Importer::Scouts.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
      VCR.use_cassette('fetch_scout_info') do
        @sl.fetch_unit_persons(:scout)
        b = (@sl.find_collection_elements_with first_name: 'Bennett', last_name: 'Smith')
        b.each {|s| @sl.fetch_person_info(:scout, s)}
      end
    end

    subject { (@sl.find_collection_elements_with first_name: 'Bennett', last_name: 'Smith').first }

    # it "does something" do
      # pp subject
    # end

    context 'loaded attributes' do
      specify { expect(subject.inspected).to be }
      specify { expect(subject.first_name).to eq('Bennett') }
      specify { expect(subject.last_name).to eq('Smith') }
      specify { expect(subject.address1).to eq('7847 E Alta Sierra Circle') }
      specify { expect(subject.city).to eq('Scottsdale') }
      specify { expect(subject.state).to eq('AZ') }
      specify { expect(subject.zip_code).to eq('85266') }
      specify { expect(subject.sub_unit).to eq('Dragons') }
      specify { expect(subject.rank).to eq('Second Class') }
      specify { expect(subject.send_reminders).to be_falsy }
      specify { expect(subject.security_level).to eq('Active - No Access') }
    end

    context 'unloaded attributes' do
      [ :leadership_position, :additional_leadership_positions, :email, :alternate_email, :home_phone, :work_phone, :cell_phone].each do |attr|
        specify { expect(subject.send(attr)).to be_nil }
      end
    end
  end


end
