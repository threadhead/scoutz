require 'spec_helper'

describe Event do
  before { stub_geocoding }

  it { should belong_to(:unit) }
  it { should have_and_belong_to_many(:users) }
  it { should have_and_belong_to_many(:sub_units) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }


  it 'creates valid event' do
    FactoryGirl.build(:event).should be_valid
  end

  describe '#end_at' do
    context 'is equal to start_at' do
      before do
        @t = Time.zone.now
        @event = FactoryGirl.build(:event, start_at: @t, end_at: @t)
      end

      subject { @event }
      it { should_not be_valid }
      it { should have_errors_on(:end_at) }
    end

    context 'is before start_at' do
      before do
        @t = Time.zone.now
        @event = FactoryGirl.build(:event, start_at: @t, end_at: @t-1)
      end

      subject { @event }
      it { should_not be_valid }
      it { should have_errors_on(:end_at) }
    end
  end

  describe '.sub_unit_kind' do
    before(:all) { @event = FactoryGirl.build(:event) }
    subject { @event.sub_unit_kind? }

    ['Den Event', 'Patrol Event'].each do |event|
      it "returns TRUE when '#{event}'" do
        @event.kind = event
        @event.sub_unit_kind?.should be_true
      end
    end

    ['Pack Event', 'Troop Event', 'Lodge Event'].each do |event|
      it "returns FALSE when '#{event}'" do
        @event.kind = event
        @event.sub_unit_kind?.should be_false
      end
    end
  end

  describe 'Event.format_time' do
    before do
      Time.zone = 'Hawaii'
      @time = Time.zone.now
      @time_format = Event.format_time(@time.to_i)
    end
    subject { @time_format }

    it { should be_a(String) }
    it { should eq(@time.utc.to_s(:db)) }
  end

  describe '.as_json' do
    before do
      @time = Time.zone.now
      @event = FactoryGirl.create(:event, start_at: @time, end_at: @time+1)
    end
    subject { @event.as_json }

    its([:id]) { should eq(@event.id) }
    its([:title]) { should eq('USS Midway Overnight') }
    its([:description]) { should eq('') }
    its([:allDay]) { should be_false }
    its([:recurring]) { should be_false }
    its([:start]) { should eq(@time.rfc822) }
    its([:end]) { should eq((@time+1).rfc822) }
    its([:url]) { should eq("/events/#{@event.id}") }
  end

end
