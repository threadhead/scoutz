require 'rails_helper'

RSpec.describe HealthForm, :type => :model do
  let(:health_form) { FactoryGirl.build(:health_form) }
  let(:health_form_expired) { FactoryGirl.build(:health_form_expired) }
  let(:health_form_empty) { FactoryGirl.build(:health_form_empty) }
  before{ Time.zone = 'Arizona' }

  it { is_expected.to belong_to(:user).touch(true) }
  it { is_expected.to belong_to(:unit) }

  describe 'validators' do
    it { is_expected.to validate_presence_of(:unit_id) }
    # it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'all_blank?' do
    it 'returns true when all health forms are empty' do
      expect(health_form_empty.all_blank?).to eq(true)
    end

    [ :part_a_date,
      :part_b_date,
      :part_c_date,
      :summit_tier_date,
      :florida_sea_base_date,
      :northern_tier_date,
      :philmont_date
      ].each do |f|
        it "returns false when field #{f} is not empty" do
          health_form_empty.send("#{f}=", Date.today)
          expect(health_form_empty.all_blank?).to eq(false)
        end
    end
  end


  describe 'expires dates' do
    {
      part_a_date:            :part_a_expires,
      part_b_date:            :part_b_expires,
      part_c_date:            :part_c_expires,
      florida_sea_base_date:  :florida_sea_base_expires,
      summit_tier_date:       :summit_tier_expires,
      philmont_date:          :philmont_expires,
      northern_tier_date:     :northern_tier_expires
    }.each do |k,v|
      it "#{v} in 1 year" do
        health_form.send("#{k}=", Date.parse('2011-02-02'))
        expect(health_form.send(v)).to eq(Date.parse('2012-02-01'))
      end
    end
  end


  describe '.valid_forms_for_event' do
    let(:event) { FactoryGirl.build(:event, type_of_health_forms: 'parts_abc') }

    # note: the event starts in 3 days, ends in 2 hours after it starts
    # note: in health_form, all forms are set for today, and expire in 1 year from today

    describe 'when all required forms do not expire before the events end time' do
      Event.type_of_health_forms.keys.drop(1).each do |type|
        it "returns true when event.type_of_health_forms = #{type}" do
          event.type_of_health_forms = type
          expect(health_form.valid_forms_for_event(event)).to be(true)
        end
      end


      describe 'but if one form is expired' do
        Event.type_of_health_forms.keys.drop(1).each do |type|
          it "returns false when event.type_of_health_forms = #{type}" do
            event.type_of_health_forms = type
            health_form.part_a_date = event.end_at - 1.year
            expect(health_form.valid_forms_for_event(event)).to be(false)
          end
        end
      end
    end


    context 'when a health form expires' do
      before do
        health_form.part_a_date = Date.parse('2010-02-02')
        health_form.part_b_date = Date.parse('2010-02-02')
        health_form.part_c_date = Date.parse('2010-02-02')
      end
      describe 'one second before the event ends' do
        it 'returns false' do
          event.end_at = Time.parse('2011-02-02 00:00:00 -0700')
          expect(health_form.valid_forms_for_event(event)).to be(false)
        end
      end


      describe 'one second after the event ends' do
        it 'returns true' do
          event.end_at = Time.zone.parse('2011-02-01 23:59:58 -0700')
          expect(health_form.valid_forms_for_event(event)).to be(true)
        end
      end


      describe 'at the same time the event ends' do
        it 'returns true' do
          event.end_at = Time.zone.parse('2011-02-01 23:59:59 -0700')
          expect(health_form.valid_forms_for_event(event)).to be(true)
        end
      end
    end



    it 'always returns false if any required health form is missing' do
      health_form.part_a_date = nil
      expect(health_form.valid_forms_for_event(event)).to eq(false)
      health_form.part_b_date = nil
      expect(health_form.valid_forms_for_event(event)).to eq(false)
      health_form.part_c_date = nil
      expect(health_form.valid_forms_for_event(event)).to eq(false)
    end


    describe 'if event is not required' do
      before{ event.type_of_health_forms = 'not_required' }

      it 'it always returns true' do
        expect(health_form_expired.valid_forms_for_event(event)).to eq(true)
        expect(health_form.valid_forms_for_event(event)).to eq(true)
      end

      it 'it always returns true, even if health form is missing' do
        health_form_expired.part_a_date = nil
        expect(health_form_expired.valid_forms_for_event(event)).to eq(true)
        health_form.part_a_date = nil
        expect(health_form.valid_forms_for_event(event)).to eq(true)
      end
    end

  end

end
