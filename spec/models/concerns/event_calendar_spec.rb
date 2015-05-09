require 'rails_helper'

RSpec.describe 'EventCalendar' do
  before do
    # allow_any_instance_of(Event).to receive(:ical_valid?).and_call_original
    Event.class_variable_set(:@@disable_ical_generation, false)
    @event = FactoryGirl.create(:event, name: 'Monster Painting', unit: @unit1, kind: 'Pack Event')
  end

  specify { expect(@event.ical_uuid).not_to be_empty }

  describe '.update_ical' do
    it 'increments the ical_sequence and saves ics file' do
      @event.reload
      ical_sequence = @event.ical_sequence
      @event.update_ical
      expect(@event.reload.ical_sequence).to eq(ical_sequence + 1)
      expect(@event.ical.present?).to be
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
      expect(IcalFilesUpdateJob).to receive(:perform_later).with(@event)
      @event.update_ical_background
    end
  end

  describe '.skip_update_ical_background_callbacks' do
    it 'calls the passed block without the after_save callback' do
      expect(Event).to receive(:skip_callback).once
      expect(Event).to receive(:set_callback).once
      d = double
      expect(d).to receive(:yieldy).once
      @event.skip_update_ical_background_callbacks { d.yieldy }
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
      @event.in_temp_file { |tf| d.yieldy }
    end
  end


  describe 'saving' do
    before { @event = FactoryGirl.build(:event, name: 'Monster Painting', unit: @unit1, kind: 'Pack Event') }

    it 'initially creates the .ics file' do
      expect(@event).to receive(:update_ical_background).exactly(1).times
      @event.save
    end

    it 'updates creates a new .ics file' do
      @event.save
      expect(@event).to receive(:update_ical_background).once
      @event.update_attribute(:name, "Whoopie!")
    end
  end

end
