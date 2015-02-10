require 'rails_helper'

RSpec.describe EventReminders do
  before { stub_geocoding }
  before(:all) { adult_2units_2scout_3subunits }

  describe 'Event.need_reminders' do
    before do
      @event1 = FactoryGirl.create(:event, start_at: 1.days.from_now, end_at: 1.days.from_now+5)
      @event2 = FactoryGirl.create(:event, start_at: 2.days.from_now, end_at: 2.days.from_now+5)
      @event3 = FactoryGirl.create(:event, start_at: 3.days.from_now, end_at: 3.days.from_now+5)
      @event4 = FactoryGirl.create(:event, start_at: 2.days.from_now+5, end_at: 2.days.from_now+10)
      @event5 = FactoryGirl.create(:event, start_at: 2.days.from_now-5, end_at: 2.days.from_now)
    end

    it 'returns events that start in 48 hours' do
      expect(Event.needs_reminders).to include(@event1)
      expect(Event.needs_reminders).to include(@event2)
      expect(Event.needs_reminders).to include(@event5)
    end

    it 'does not return events that start > 48 hours' do
      expect(Event.needs_reminders).not_to include(@event3)
      expect(Event.needs_reminders).not_to include(@event4)
    end

    it 'does not return events that are do no require reminders' do
      @event1.update_attribute(:send_reminders, false)
      expect(Event.needs_reminders).not_to include(@event1)
    end

    it 'does not return events that reminders have already been sent' do
      @event1.update_attribute(:reminder_sent_at, Time.zone.now)
      expect(Event.needs_reminders).not_to include(@event1)
    end
  end


  describe '.users_to_email' do
    ['Pack Event', 'Troop Event', 'Crew Event', 'Lodge Event', 'Troop Meeting', 'Pack Meeting', 'Crew Meeting', 'Camping/Outing', 'PLC', 'Lodge Meeting'].each do |kind|
      context "event kind: #{kind}" do
        it 'returns all unit members' do
          @event = FactoryGirl.build(:event, unit: @unit1, kind: kind)
          expect(@event.users_to_email).to include(@adult)
          expect(@event.users_to_email).not_to include(@scout1)
          expect(@event.users_to_email).not_to include(@scout2)
        end
      end
    end

    it 'returns all unit leaders' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Adult Leader Event')
      expect(@event.users_to_email).to include(@adult)
      expect(@event.users_to_email).not_to include(@scout1)
      expect(@event.users_to_email).not_to include(@scout2)
    end

    it 'returns all selected sub unit members' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Den Event', sub_unit_ids: [@sub_unit1.id])
      expect(@event.users_to_email).to include(@adult)
      expect(@event.users_to_email).not_to include(@scout1)
      expect(@event.users_to_email).not_to include(@scout2)
    end
  end


  describe '.recipients_emails' do
    ['Pack Event', 'Troop Event', 'Crew Event', 'Lodge Event', 'Troop Meeting', 'Pack Meeting', 'Crew Meeting', 'Camping/Outing', 'PLC', 'Lodge Meeting'].each do |kind|
      context "event kind: #{kind}" do
        it 'returns all unit members' do
          @event = FactoryGirl.build(:event, unit: @unit1, kind: kind)
          expect(@event.recipients_emails).to include(@adult.email)
          expect(@event.recipients_emails).not_to include(@scout1.email)
          expect(@event.recipients_emails).not_to include(@scout2.email)
        end
      end
    end

    it 'returns all unit leaders' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Adult Leader Event')
      expect(@event.recipients_emails).to include(@adult.email)
      expect(@event.recipients_emails).not_to include(@scout1.email)
      expect(@event.recipients_emails).not_to include(@scout2.email)
    end

    it 'returns all selected sub unit members' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Den Event', sub_unit_ids: [@sub_unit1.id])
      expect(@event.recipients_emails).to include(@adult.email)
      expect(@event.recipients_emails).not_to include(@scout1.email)
      expect(@event.recipients_emails).not_to include(@scout2.email)
    end
  end


  describe '.recipients_sms_emails' do
    ['Pack Event', 'Troop Event', 'Crew Event', 'Lodge Event', 'Troop Meeting', 'Pack Meeting', 'Crew Meeting', 'Camping/Outing', 'PLC', 'Lodge Meeting'].each do |kind|
      context "event kind: #{kind}" do
        it 'returns all unit members' do
          @event = FactoryGirl.build(:event, unit: @unit1, kind: kind)
          expect(@event.recipients_sms_emails).to include(@adult.sms_email_address)
          expect(@event.recipients_sms_emails).not_to include(@adult2.sms_email_address)
          expect(@event.recipients_sms_emails).not_to include(@scout1.sms_email_address)
          expect(@event.recipients_sms_emails).not_to include(@scout2.sms_email_address)
          expect(@event.recipients_sms_emails).to include(@scout3.sms_email_address)
        end
      end
    end

    it 'returns all unit leaders' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Adult Leader Event')
      expect(@event.recipients_sms_emails).to include(@adult.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@adult2.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@scout1.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@scout2.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@scout3.sms_email_address)
    end

    it 'returns all selected sub unit members' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Den Event', sub_unit_ids: [@sub_unit1.id])
      expect(@event.recipients_sms_emails).to include(@adult.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@adult2.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@scout1.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@scout2.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@scout3.sms_email_address)

      @event = FactoryGirl.build(:event, unit: @unit2, kind: 'Den Event', sub_unit_ids: [@sub_unit2.id])
      expect(@event.recipients_sms_emails).to include(@adult.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@adult2.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@scout1.sms_email_address)
      expect(@event.recipients_sms_emails).to include(@scout2.sms_email_address)
      expect(@event.recipients_sms_emails).not_to include(@scout3.sms_email_address)
    end
  end


  describe '.email_reminder_subject' do
    it 'retruns the name of the event with reminder suffix' do
      @event = FactoryGirl.build(:event, name: 'Monster Painting', unit: @unit1, kind: 'Pack Event')
      expect(@event.email_reminder_subject).to eq('Monster Painting - Reminder [CS Pack 134]')
    end
  end

  describe '.sms_reminder_subject' do
    it 'retruns the name of the event, truncated, with reminder suffix' do
      @event = FactoryGirl.build(:event, name: 'Monster Painting On the Sea of Tranquility', unit: @unit1, kind: 'Pack Event')
      expect(@event.sms_reminder_subject).to eq('Monster Painting On the... - Reminder')
    end
  end


  describe '.send_reminder' do
    before do
      allow_any_instance_of(Event).to receive(:ical_valid?).and_call_original
      ActionMailer::Base.deliveries.clear
      @event = FactoryGirl.create(:event, unit: @unit1, kind: 'Pack Event')
      adult2 = FactoryGirl.create(:adult)
      adult2.units << @unit1
    end

    it 'sends one email to all event recipients' do
      @event.send_reminder
      expect(ActionMailer::Base.deliveries.size).to eq(5) # 3 emails, 2 sms
      # ap ActionMailer::Base.deliveries
    end

    it 'if signup required, sends separate emails and smsto all event recipients' do
      @event.signup_required = true
      @event.signup_deadline = Time.zone.now
      @event.send_reminder
      expect(ActionMailer::Base.deliveries.size).to eq(5) # 3 emails, 2 sms
    end
  end


end
