require 'spec_helper'

RSpec.describe Event do
  before { stub_geocoding }
  before(:all) do
    adult_2units_2scout_3subunits
  end

  it { should belong_to(:unit) }
  it { should have_and_belong_to_many(:users) }
  it { should have_and_belong_to_many(:sub_units) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }
  it { should validate_presence_of(:message) }
  it { should validate_uniqueness_of(:sl_profile).allow_nil }

  specify { expect(FactoryGirl.build(:event)).to be_valid }

  describe '#end_at' do
    context 'is equal to start_at' do
      before do
        @t = Time.zone.now
        @event = FactoryGirl.build(:event, start_at: @t, end_at: @t)
        @event.valid?
      end

      specify { expect(@event).not_to be_valid }
      specify { expect(@event.errors).to include(:end_at) }
    end

    context 'is before start_at' do
      before do
        @t = Time.zone.now
        @event = FactoryGirl.build(:event, start_at: @t, end_at: @t-1)
        @event.valid?
      end

      specify { expect(@event).not_to be_valid }
      specify { expect(@event.errors).to include(:end_at) }
    end
  end

  describe '.sub_unit_kind' do
    before(:all) { @event = FactoryGirl.build(:event) }
    subject { @event.sub_unit_kind? }

    ['Den Event', 'Patrol Event'].each do |event|
      it "returns TRUE when '#{event}'" do
        @event.kind = event
        expect(@event.sub_unit_kind?).to be
      end
    end

    ['Pack Event', 'Troop Event', 'Lodge Event'].each do |event|
      it "returns FALSE when '#{event}'" do
        @event.kind = event
        expect(@event.sub_unit_kind?).to be_falsy
      end
    end
  end


  describe 'Event.format_time' do
    before do
      Time.zone = 'Hawaii'
      @time = Time.zone.now
      @time_format = Event.format_time(@time.to_i)
    end

    specify { expect(@time_format).to be_a(String) }
    specify { expect(@time_format).to eq(@time.utc.to_s(:db)) }
  end


  describe '.as_json' do
    before(:all) do
      @time = Time.zone.now
      @unit = FactoryGirl.create(:unit)
      @event = FactoryGirl.build_stubbed(:event, unit: @unit, start_at: @time, end_at: @time+1)
    end
    subject { @event.as_json }

    specify { expect(subject[:id]).to eq(@event.id) }
    specify { expect(subject[:title]).to eq('USS Midway Overnight') }
    specify { expect(subject[:description]).to eq('') }
    specify { expect(subject[:allDay]).to be_falsy }
    specify { expect(subject[:recurring]).to be_falsy }
    specify { expect(subject[:start]).to eq(@time.rfc822) }
    specify { expect(subject[:end]).to eq((@time+1).rfc822) }
    specify { expect(subject[:url]).to eq("/units/#{@unit.id}/events/#{@event.id}") }
  end

  describe '.after_signup_deadline?' do
    before { @event = FactoryGirl.build(:event, signup_deadline: Time.zone.now)}

    it 'retuns true when signup has passed' do
      @event.signup_deadline = 3.seconds.ago
      expect(@event.after_signup_deadline?).to be
    end

    it 'return false when signup has NOT passed' do
      @event.signup_deadline = 3.seconds.from_now
      expect(@event.after_signup_deadline?).to be_falsy
    end
  end


end
