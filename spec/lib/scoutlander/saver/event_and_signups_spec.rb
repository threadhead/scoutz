require 'rails_helper'

RSpec.describe Scoutlander::Saver::EventAndSignups do
  before(:all) do
    @unit = FactoryGirl.create(:unit)
    @scout = FactoryGirl.create(:scout)
    @scout.units << @unit
  end

  before do
    @datum = Scoutlander::Datum::Event.new(name: "Flubber", sl_profile: '654321')
    @event = FactoryGirl.create(:event, name: 'Minnie', unit: @unit, sl_profile: '654321')
    @event_signup = FactoryGirl.create(:event_signup, event: @event, user: @scout)
  end


  let(:event_saver) { Scoutlander::Saver::EventAndSignups.new(unit: @unit, event: @datum ) }


  describe '.create_or_update_event' do
    context 'with existing event' do
      it 'updates info' do
        # allow(event_saver).to receive(:create_or_update_event_signups)
        expect(@event.name).to eq('Minnie')
        event_saver.create_or_update_event
        @event.reload
        expect(@event.name).to eq('Flubber')
      end

      it 'does not disable reminders even if old' do
        expect(@event).not_to receive(:disable_reminder_if_old)
        @event.update_attributes(start_at: 1.year.ago, reminder_sent_at: 38.days.ago)
        event_saver.create_or_update_event
        @event.reload
        expect(@event.reminder_sent_at).to be_within(2).of(38.days.ago)
      end
    end

    context 'without existing event' do
      before do
        @datum.sl_profile = '123456'
        @datum.start_at = Time.now
        @datum.end_at = Time.now
        @datum.message = 'Something'
        @datum.kind = 'Event'
      end

      it 'creates new event' do
        expect_any_instance_of(Event).to receive(:disable_reminder_if_old)
        # allow(event_saver).to receive(:create_or_update_event_signups)
        event_saver.create_or_update_event
        expect(Event.where(sl_profile: '123456')).to exist
      end

      it 'disables reminders if start_at before 2 days ago' do
        @datum.start_at = 1.year.ago
        event_saver.create_or_update_event
        expect(Event.where(sl_profile: '123456').first.reminder_sent_at).to be_within(2).of(Time.at(0))
      end

      it 'disables reminders if start_at before 2 days ago' do
        expect_any_instance_of(Event).to receive(:disable_reminder_if_old)
        @datum.start_at = 1.day.ago
        event_saver.create_or_update_event
        expect(Event.where(sl_profile: '123456').first.reminder_sent_at).to be_nil
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
        expect(@event.event_signups.joins(:scout).where(user_id: @scout.id).count).to eq(0)
        event_saver.create_or_update_event_signups
        expect(@event.event_signups.count).to eq(1)
        expect(@event.event_signups.first.user_id).to eq(@scout.id)
      end

      it 'removes existing signups' do
        expect(@event.event_signups.first.user_id).not_to be_blank
        event_saver.create_or_update_event_signups
        expect(@event.event_signups.first.user_id).to eq(@scout.id)
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
