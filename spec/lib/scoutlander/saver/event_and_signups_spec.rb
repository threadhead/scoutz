require 'rails_helper'

RSpec.describe Scoutlander::Saver::EventAndSignups do
  before(:all) do
    @unit = FactoryGirl.create(:unit)
  end

  before do
    @datum = Scoutlander::Datum::Event.new(name: "Flubber", sl_profile: '654321')
    @event = FactoryGirl.create(:event, name: 'Minnie', unit: @unit, sl_profile: '654321')
    @event_signup = FactoryGirl.create(:event_signup, event: @event)
  end


  let(:event_saver) { Scoutlander::Saver::EventAndSignups.new(unit: @unit, event: @datum ) }

  describe '.create_or_update_event' do
    context 'with existing event' do
      it 'updates info' do
        allow(event_saver).to receive(:create_or_update_event_signups)
        expect(@event.name).to eq('Minnie')
        event_saver.create_or_update_event
        @event.reload
        expect(@event.name).to eq('Flubber')
      end
    end

    context 'without existing event' do
      it 'creates new event' do
        allow(event_saver).to receive(:create_or_update_event_signups)
        @datum.sl_profile = '123456'
        @datum.start_at = Time.now
        @datum.end_at = Time.now
        @datum.message = 'Something'
        event_saver.create_or_update_event
        expect(Event.where(sl_profile: '123456')).to exist
      end
    end
  end


  describe 'create_or_update_event_signups' do
    context 'with signups' do
      before(:all) do
        @scout = FactoryGirl.create(:scout, sl_profile: '888999')
        @unit.scouts << @scout
      end
      before do
        @signup = Scoutlander::Datum::EventSignup.new(scouts_attending: 1, inspected: true, sl_profile: '888999')
        @datum.add_signup @signup
        event_saver.event = @event
      end

      it 'adds signup to existing event' do
        expect(@event.event_signups.joins(:scout).where(scout_id: @scout.id).count).to eq(0)
        event_saver.create_or_update_event_signups
        expect(@event.event_signups.count).to eq(1)
        expect(@event.event_signups.first.scout_id).to eq(@scout.id)
      end

      it 'removes existing signups' do
        expect(@event.event_signups.first.scout_id).to be_blank
        event_saver.create_or_update_event_signups
        expect(@event.event_signups.first.scout_id).to eq(@scout.id)
      end

      it 'does not save signups without matching scout' do
        signup_ids = @event.event_signups.pluck(:id)
        @signup.sl_profile = '777666'
        event_saver.create_or_update_event_signups
        expect(@event.event_signups.pluck(:id)).to eq(signup_ids)
      end
    end

    context 'without signups' do
      # it 'does nothing' do

      # end
    end
  end

end
