require 'rails_vcr_helper'

RSpec.describe Scoutlander::Reader::Scouts do
  before(:all) { @unit = FactoryGirl.create(:unit, sl_uid: '3218', unit_type: 'Boy Scouts') }

  describe '.fetch_unit_persons', :vcr do
    before(:all) do
      @sl = Scoutlander::Reader::Scouts.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
      VCR.use_cassette('fetch_unit_scouts') do
        @sl.fetch_unit_scouts
      end
    end

    subject { (@sl.find_collection_elements_with first_name: 'Devin', last_name: 'Goins').first }



    specify { expect(subject).to_not be_blank }

    context 'loaded attributes' do
      specify { expect(subject.sl_profile).to eq('365175') }
      specify { expect(subject.sl_uid).to eq('3218') }
      specify { expect(subject.sl_url).not_to be_blank }
    end

    context 'unloaded attributes' do
      [ :sub_unit, :leadership_position, :additional_leadership_positions, :security_level, :email, :alternate_email, :send_reminders, :home_phone, :work_phone, :cell_phone, :address1, :city, :state, :zip_code, :rank].each do |attr|
        it "attribute #{attr} is nil" do
          expect(subject.send(attr)).to be_nil
        end
      end
    end
  end




  describe '.fetch_scout_info', :vcr do
    before(:all) do
      @sl = Scoutlander::Reader::Scouts.new(email: 'threadhead@gmail.com', password: ENV['SCOUTLANDER_PASSWORD'], unit: @unit)
      VCR.use_cassette('fetch_scout_info') do
        @sl.fetch_unit_scouts
        b = (@sl.find_collection_elements_with first_name: 'Devin', last_name: 'Goins')
        b.each {|s| @sl.fetch_person_info(:scout, s)}
      end
    end

    subject { (@sl.find_collection_elements_with first_name: 'Devin', last_name: 'Goins').first }

    # it "does something" do
      # pp subject
    # end

    context 'loaded attributes' do
      specify { expect(subject.inspected).to eq(true) }
      specify { expect(subject.first_name).to eq('Devin') }
      specify { expect(subject.last_name).to eq('Goins') }
      specify { expect(subject.address1).to eq('4628 E Matt Dillon Trail') }
      specify { expect(subject.city).to eq('Cave Creek ') }
      specify { expect(subject.state).to eq('AZ') }
      specify { expect(subject.zip_code).to eq('85331') }
      specify { expect(subject.sub_unit).to eq('Desert Dogs') }
      specify { expect(subject.rank).to eq('First Class') }
      specify { expect(subject.send_reminders).to eq(true) }
      specify { expect(subject.security_level).to eq('Scout Access') }
      specify { expect(subject.leadership_position).to eq('Asst Senior Patrol Leader') }
      specify { expect(subject.additional_leadership_positions).to eq('Den Chief Pack 134') }
      specify { expect(subject.email).to eq('azdevin13@hotmail.com') }
      specify { expect(subject.home_phone).to eq('480-655-5355') }
      specify { expect(subject.cell_phone).to eq('480-322-4299') }
    end

    context 'unloaded attributes' do
      [ :alternate_email, :work_phone].each do |attr|
        specify { expect(subject.send(attr)).to be_nil }
      end
    end
  end


end
