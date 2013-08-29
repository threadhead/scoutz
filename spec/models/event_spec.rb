require 'spec_helper'

describe Event do
  before { stub_geocoding }
  before(:all) do
    adult_2units_2scout_3subunits
  end

  it { should belong_to(:unit) }
  # it { should have_and_belong_to_many(:users) }
  # it { should have_and_belong_to_many(:sub_units) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }
  it { should validate_presence_of(:message) }


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

  describe '.after_signup_deadline?' do
    before { @event = FactoryGirl.build(:event, signup_deadline: Time.zone.now)}

    it 'retuns true when signup has passed' do
      @event.signup_deadline = 3.seconds.ago
      @event.after_signup_deadline?.should be_true
    end

    it 'return false when signup has NOT passed' do
      @event.signup_deadline = 3.seconds.from_now
      @event.after_signup_deadline?.should be_false
    end
  end

  describe 'Event.need_reminders' do
    before do
      @event1 = FactoryGirl.create(:event, start_at: Time.now, end_at: 1.days.from_now)
      @event2 = FactoryGirl.create(:event, start_at: Time.now, end_at: 2.days.from_now)
      @event3 = FactoryGirl.create(:event, start_at: Time.now, end_at: 3.days.from_now)
      @event4 = FactoryGirl.create(:event, start_at: Time.now, end_at: 2.days.from_now+5)
      @event5 = FactoryGirl.create(:event, start_at: Time.now, end_at: 2.days.from_now-5)
    end

    it 'returns events that end in 48 hours' do
      Event.need_reminders.should include(@event1)
      Event.need_reminders.should include(@event2)
      Event.need_reminders.should include(@event5)
    end

    it 'does not return events that end > 48 hours' do
      Event.need_reminders.should_not include(@event3)
      Event.need_reminders.should_not include(@event4)
    end

    it 'does not return events that are do no require reminders' do
      @event1.update_attribute(:send_reminders, false)
      Event.need_reminders.should_not include(@event1)
    end

    it 'does not return events that reminders have already been sent' do
      @event1.update_attribute(:reminder_sent_at, Time.zone.now)
      Event.need_reminders.should_not include(@event1)
    end
  end


  describe '.recipients' do
    it 'returns all unit members' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Pack Event')
      @event.recipients.should include(@adult)
      @event.recipients.should_not include(@scout1)
      @event.recipients.should_not include(@scout2)
    end

    it 'returns all unit leaders' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Leader Event')
      @event.recipients.should include(@adult)
      @event.recipients.should_not include(@scout1)
      @event.recipients.should_not include(@scout2)
    end

    it 'returns all selected sub unit members' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Den Event', sub_unit_ids: [@sub_unit1.id])
      @event.recipients.should include(@adult)
      @event.recipients.should_not include(@scout1)
      @event.recipients.should_not include(@scout2)
    end
  end


  describe '.recipients_emails' do
    it 'returns all unit members' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Pack Event')
      @event.recipients_emails.should include(@adult.email)
      @event.recipients_emails.should_not include(@scout1.email)
      @event.recipients_emails.should_not include(@scout2.email)
    end

    it 'returns all unit leaders' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Leader Event')
      @event.recipients_emails.should include(@adult.email)
      @event.recipients_emails.should_not include(@scout1.email)
      @event.recipients_emails.should_not include(@scout2.email)
    end

    it 'returns all selected sub unit members' do
      @event = FactoryGirl.build(:event, unit: @unit1, kind: 'Den Event', sub_unit_ids: [@sub_unit1.id])
      @event.recipients_emails.should include(@adult.email)
      @event.recipients_emails.should_not include(@scout1.email)
      @event.recipients_emails.should_not include(@scout2.email)
    end
  end

  describe '.reminder_subject' do
    it 'retruns the name of the event with reminder suffix' do
      @event = FactoryGirl.build(:event, name: 'Monster Painting', unit: @unit1, kind: 'Pack Event')
      @event.reminder_subject.should eq('[CS Pack 134] Monster Painting - Reminder')
    end
  end

  describe '.send_reminder' do
    before do
      @event = FactoryGirl.create(:event, unit: @unit1, kind: 'Pack Event')
      adult2 = FactoryGirl.build(:adult)
      adult2.units << @unit1
    end

    it 'sends one email to all event recipients' do
      @event.send_reminder
      ActionMailer::Base.deliveries.size.should eq(1)
    end

    it 'sends separate emails to all event recipients' do
      @event.signup_required = true
      @event.signup_deadline = Time.zone.now
      @event.send_reminder
      ActionMailer::Base.deliveries.size.should eq(2)
    end
  end

  describe 'saving' do
    before { @event = FactoryGirl.build(:event, name: 'Monster Painting', unit: @unit1, kind: 'Pack Event') }

    it 'initially creates the .ics file' do
      expect(@event).to receive(:update_ical_background).exactly(1).times
      @event.save
    end

    it 'with updates creates a new .ics file' do
      @event.save
      expect(@event).to receive(:update_ical_background).once
      @event.update_attribute(:name, "Whoopie!")
    end
  end

  describe 'EventCalendar' do
    before { @event = FactoryGirl.create(:event, name: 'Monster Painting', unit: @unit1, kind: 'Pack Event') }

    specify { expect(@event.ical_uuid).not_to be_empty }

    describe '.update_ical' do
      it 'increments the ical_sequence and saves ics file' do
        @event.reload
        ical_sequence = @event.ical_sequence
        @event.update_ical
        expect(@event.reload.ical_sequence).to eq(ical_sequence + 1)
        expect(@event.ical.present?).to be_true
      end
    end

    describe 'Event.update_ical' do
      it 'finds the event with id and calls event.update_ical' do
        expect(Event).to receive(:find).with(@event.id).and_return(@event)
        Event.any_instance.should_receive(:update_ical)
        Event.update_ical(@event.id)
      end
    end

    describe '.update_ical_background' do
      it 'add an update_ical to the background queue' do
        d = double
        expect(Event).to receive(:delay).and_return(d)
        expect(d).to receive(:update_ical).with(@event.id)
        @event.update_ical_background
      end
    end

    describe '.skip_update_ical_background_callbacks' do
      it 'calls the passed block without the after_save callback' do
        expect(Event).to receive(:skip_callback).once
        expect(Event).to receive(:set_callback).once
        d = double
        expect(d).to receive(:yieldy).once
        @event.skip_update_ical_background_callbacks{ d.yieldy }
      end
    end

    describe '.in_temp_file' do
      it 'creates a temporary file for use, calls the passed block, then deletes it' do
        tf = double
        expect(Tempfile).to receive(:new).with([@event.ical_uuid, '.ics']).and_return(tf)
        expect(tf).to receive(:close)
        expect(tf).to receive(:unlink)
        d = double
        expect(d).to receive(:yieldy).once
        @event.in_temp_file{ |tf| d.yieldy }
      end
    end
  end

end
