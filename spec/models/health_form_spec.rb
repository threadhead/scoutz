require 'rails_helper'

RSpec.describe HealthForm, :type => :model do
  let(:health_form) { FactoryGirl.build(:health_form) }
  let(:health_form_expired) { FactoryGirl.build(:health_form_expired) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:unit) }

  describe 'validators' do
    it { is_expected.to validate_presence_of(:unit_id) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'expires dates' do
    {
      part_a_date: :part_a_expires,
      part_b_date: :part_b_expires,
      part_c_date: :part_c_expires,
      florida_sea_base_date: :florida_sea_base_expires,
      summit_tier_date: :summit_tier_expires,
      philmont_date: :philmont_expires,
      northern_tier_date: :northern_tier_expires
    }.each do |k,v|
      it "#{v} in 1 year" do
        health_form.send("#{k}=", Date.parse('2011-02-02'))
        expect(health_form.send(v)).to eq(Date.parse('2012-02-01'))
      end
    end
  end


  describe '.valid_forms_for_event' do
    let(:event) { FactoryGirl.build(:event, type_of_health_forms: 'parts_abc') }

    describe 'when all required forms do not expire before the events ending time' do
      Event.type_of_health_forms.keys.each do |type|
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
