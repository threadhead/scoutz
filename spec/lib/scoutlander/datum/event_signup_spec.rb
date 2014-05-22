require 'spec_helper'

describe Scoutlander::Datum::EventSignup do
  let(:event_signup) { Scoutlander::Datum::EventSignup.new(scouts_attending: 1) }
  subject { event_signup }

  context 'when initialized' do
    specify { expect(subject.comment).to be_nil }
    specify { expect(subject.scouts_attending).to eq(1) }
    specify { expect(subject.adults_attending).to eq(0) }
    specify { expect(subject.siblings_attending).to eq(0) }
    specify { expect(subject.inspected).to be_false }
  end

  describe '.to_params' do
    specify { expect(subject.to_params).not_to have_key(:included) }
    specify { expect(subject.to_params).not_to have_key(:sl_profile) }
    specify { expect(subject.to_params).to have_key(:scouts_attending) }
    specify { expect(subject.to_params).to have_key(:siblings_attending) }
  end


  describe ".valid?" do
    describe "returns true" do
      it "when inspected and at least one attending" do
        subject.inspected = true
        expect(subject.valid?).to be_true
      end
    end


    describe "returns false" do
      it "when inspected is false" do
        subject.inspected = false
        expect(subject.valid?).to be_false
      end

      it "when all attendings are 0" do
        subject.inspected = true
        subject.scouts_attending = 0
        expect(subject.valid?).to be_false
      end
    end
  end
end
