require 'rails_helper'

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
    specify { expect(subject[:start]).to eq(@time.iso8601) }
    specify { expect(subject[:end]).to eq((@time+1).iso8601) }
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
      expect(@event.after_signup_deadline?).to eq(false)
    end
  end



  describe '.disable_reminder_if_old' do
    let(:event) { FactoryGirl.build(:event) }

    it 'sets reminder_sent_at to epoch if it starts more than 2 days ago' do
      event.start_at = 2.days.ago
      event.disable_reminder_if_old
      expect(event.reminder_sent_at).to be_within(2).of(Time.at(0))
    end

    it 'does nothing to reminder_sent_at if it starts less than 2 days ago' do
      event.start_at = 1.days.ago
      event.disable_reminder_if_old
      expect(event.reminder_sent_at).to be_nil
    end
  end



  context 'form coordinators' do
    before(:all) do
      @basic_adult = FactoryGirl.create(:adult, role: :basic)
      @basic_adult.units << @unit1
      @admin_adult = FactoryGirl.create(:adult, role: :admin)
      @admin_adult.units << @unit1
    end
    let(:event) { FactoryGirl.build_stubbed(:event, unit: @unit1) }


    describe '.form_coordinators' do
      it 'no coordinators selected, return all adults with role=leader or above' do
        expect(event.form_coordinators).to include(@adult)
        expect(event.form_coordinators).to include(@admin_adult)
        expect(event.form_coordinators).not_to include(@basic_adult)
        expect(event.form_coordinators).not_to include(@scout1)
      end

      it 'when coordinators specified, it returns only those selected' do
        event.form_coordinator_ids << @basic_adult.id.to_s
        expect(event.form_coordinators).to include(@basic_adult)
        expect(event.form_coordinators).not_to include(@admin_adult)
        expect(event.form_coordinators).not_to include(@adult)
        expect(event.form_coordinators).not_to include(@scout1)
      end
    end


    describe '.form_coordinator?(user)' do
      context 'when no coordinators specified' do
        it 'returns true for admins and leaders' do
          expect(event.form_coordinator?(@admin_adult)).to eq(true)
          expect(event.form_coordinator?(@adult)).to eq(true)
        end

        it 'returns false for all others' do
          expect(event.form_coordinator?(@basic_adult)).to eq(false)
          expect(event.form_coordinator?(@scout1)).to eq(false)
        end
      end

      context 'when coordinators sepcified' do
        before { event.form_coordinator_ids << @basic_adult.id.to_s }

        it 'returns true for admins and coordinators' do
          expect(event.form_coordinator?(@admin_adult)).to eq(true)
          expect(event.form_coordinator?(@basic_adult)).to eq(true)
        end

        it 'returns false for all others' do
          expect(event.form_coordinator?(@adult)).to eq(false)
          expect(event.form_coordinator?(@scout1)).to eq(false)
        end
      end
    end

    describe '.has_form_coordinators' do
      it 'returns false when no coordinators are specified' do
        expect(event.has_form_coordinators).to eq(false)
      end
      it 'returns true when coordinators are specified' do
        event.form_coordinator_ids << @basic_adult.id.to_s
        expect(event.has_form_coordinators).to eq(true)
      end
    end
  end



  describe '.health_forms_required?' do
    let(:event) { FactoryGirl.build(:event) }

    it 'return false when no health forms are required' do
      event.type_of_health_forms = :not_required.to_s
      expect(event.health_forms_required?).to eq(true)
    end

    [ :parts_ab,
      :parts_abc,
      :northern_tier,
      :florida_sea_base,
      :philmont,
      :summit
      ].each do |f|
        it "returns true when health forms #{f} is rquired" do
          event.type_of_health_forms = f.to_s
          expect(event.health_forms_required?).to eq(true)
        end
    end
  end



end
