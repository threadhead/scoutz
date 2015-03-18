require 'rails_helper'

RSpec.describe EventSignup do
  it { should belong_to(:event).touch(true) }
  it { should belong_to(:user) }

  it { should validate_numericality_of(:adults_attending) }
  it { should validate_numericality_of(:scouts_attending) }
  it { should validate_numericality_of(:siblings_attending) }
  # it { should validate_uniqueness_of(:scout_id).scoped_to(:event_id) }

  # validations
  it 'should have at least one person attending' do
    @event_signup = FactoryGirl.build(:event_signup, scouts_attending: 0)
    @event_signup.should_not be_valid
    # @event_signup.should have(1).error_on(:base)
    expect(@event_signup.errors.count).to eq(2)
    expect(@event_signup.errors).to include(:base)
    expect(@event_signup.errors).to include(:user_id)
  end


  describe 'update event attendee counts' do
    before do
      @event = FactoryGirl.create(:event)
      @scout = FactoryGirl.create(:scout)
      @event_signup = FactoryGirl.build(:event_signup, event: @event, user: @scout)
    end

    it 'on save' do
      @event_signup.should_receive(:update_event_attendee_count)
      @event_signup.save
    end

    it 'on update' do
      @event_signup.save
      @event_signup.should_receive(:update_event_attendee_count)
      @event_signup.update_attribute(:adults_attending, 3)
    end
  end


  context '.cancelled?' do
    before { @event_signup = FactoryGirl.build(:event_signup) }

    it 'returns true when canceled' do
      @event_signup.canceled_at = Time.zone.now
      expect(@event_signup.canceled?).to be
    end

    it 'returns false when not canceled' do
      expect(@event_signup.canceled?).to be_falsy
    end
  end

  context '.unit' do
    before do
      @unit = FactoryGirl.create(:unit)
      @event = FactoryGirl.create(:event, unit: @unit)
      @event_signup = FactoryGirl.build(:event_signup, event: @event)
    end

    it 'retuns the associated events unit' do
      @event_signup.unit.should eq(@unit)
    end
  end
end
