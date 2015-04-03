require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.describe Google::TimeDisplay do

  context 'in the current year, displays no year' do
    before { travel_to DateTime.new(2001, 2, 2, 0, 0, 0) }
    after { travel_back }

    let(:start_time) { Time.zone.now }
    let(:end_time) { 1.hour.from_now }

    it 'displays at date and time' do
      expect(Google::TimeDisplay.new(start_time).to_s).to eq('Fri, February 2, 12am')
    end

    it 'displays the range with only time when stat and end are on same day' do
      expect(Google::TimeDisplay.new(start_time, end_time).to_s).to eq('Fri, February 2, 12am - 1am')
    end

    it 'displays the range in full when stat and end are on different days' do
      expect(Google::TimeDisplay.new(start_time, end_time + 1.day).to_s).to eq('Fri, February 2, 12am - Sat, February 3, 1am')
    end

    it 'displays the hour only when no minutes' do
      expect(Google::TimeDisplay.new(start_time).to_s).to eq('Fri, February 2, 12am')
    end

    it 'displays the hour plus minutes' do
      expect(Google::TimeDisplay.new(start_time + 1.minute).to_s).to eq('Fri, February 2, 12:01am')
    end

    it 'displays the hour plus minutes if any time has minutes' do
      expect(Google::TimeDisplay.new(start_time + 1.minute, end_time).to_s).to eq('Fri, February 2, 12:01am - 1:00am')
    end



    it 'does not abbreviate month' do
      expect(Google::TimeDisplay.new(start_time).abbr_month(false).to_s).to eq('Fri, February 2, 12am')
    end

    it 'abbreviates month' do
      expect(Google::TimeDisplay.new(start_time).abbr_month(true).to_s).to eq('Fri, Feb 2, 12am')
      expect(Google::TimeDisplay.new(start_time).abbr_month.to_s).to eq('Fri, Feb 2, 12am')
    end




    it 'shows weekday' do
      expect(Google::TimeDisplay.new(start_time).show_weekday.to_s).to eq('Fri, February 2, 12am')
    end

    it 'hides weekday weekday' do
      expect(Google::TimeDisplay.new(start_time).show_weekday(false).to_s).to eq('February 2, 12am')
      expect(Google::TimeDisplay.new(start_time).hide_weekday.to_s).to eq('February 2, 12am')
    end

    it 'does not abbreviate weekday' do
      expect(Google::TimeDisplay.new(start_time).abbr_weekday(false).to_s).to eq('Friday, February 2, 12am')
    end

  end



  context 'in a different year, displayes the year' do
    before { travel_to DateTime.new(2001, 2, 2, 0, 0, 0) }
    after { travel_back }

    let(:start_time) { DateTime.new(2002, 2, 2, 0, 0, 0) }
    let(:end_time) { DateTime.new(2002, 2, 2, 1, 0, 0) }

    it 'displays at date and time' do
      expect(Google::TimeDisplay.new(start_time).to_s).to eq('Sat, February 2, 2002, 12am')
    end

    it 'displays the range with only time when stat and end are on same day' do
      expect(Google::TimeDisplay.new(start_time, end_time).to_s).to eq('Sat, February 2, 2002, 12am - 1am')
    end

    it 'displays the range in full when stat and end are on different days' do
      expect(Google::TimeDisplay.new(start_time, end_time + 1.day).to_s).to eq('Sat, February 2, 2002, 12am - Sun, February 3, 2002, 1am')
    end

    it 'displays the hour only when no minutes' do
      expect(Google::TimeDisplay.new(start_time).to_s).to eq('Sat, February 2, 2002, 12am')
    end

    it 'displays the hour plus minutes' do
      expect(Google::TimeDisplay.new(start_time + 1.minute).to_s).to eq('Sat, February 2, 2002, 12:01am')
    end

    it 'displays the hour plus minutes if any time has minutes' do
      expect(Google::TimeDisplay.new(start_time + 1.minute, end_time).to_s).to eq('Sat, February 2, 2002, 12:01am - 1:00am')
    end
  end
end
