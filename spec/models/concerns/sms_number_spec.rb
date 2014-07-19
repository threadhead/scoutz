require 'rails_helper'

class Person
  include ActiveModel::Validations
  # include ActiveModel::Conversion
  # extend ActiveModel::Naming

  include SmsNumber
  def initialize
    @sms_number = '888-555-4444'
  end
  def sms_number
    @sms_number
  end
  def sms_number=(val)
    @sms_number = val
  end
  def sms_provider
    'T-Mobile'
  end
end

class Droid
  include ActiveModel::Validations
  # include ActiveModel::Conversion
  # extend ActiveModel::Naming

  include SmsNumber
end


RSpec.describe 'SmsNumber Concern' do
  context 'Person class, with appropriate attributes' do
    let(:p) { Person.new }


    specify { expect(Person.sms_providers).not_to be_empty }
    specify { expect(Person.sms_providers).to be_a(Array) }

    specify { expect(p.sms_email_domain).to eq('tmomail.net') }

    describe 'sms_number validation' do
      it 'valid when 10 digits' do
        expect(p).to be_valid
        p.sms_number = 'asdf8885554444asdf'
        expect(p).to be_valid
      end

      it 'invalid when not 10 digits' do
        p.sms_number = '8'
        expect(p).not_to be_valid
        # expect(p.errors.count).to eq(1) # make test 10X slower ???
        expect(p.errors).to include(:sms_number)

        p.sms_number = '01234567890'
        expect(p).not_to be_valid
        p.sms_number = '01234asdf567890'
        expect(p).not_to be_valid
      end
    end

    it 'cleans sms_number by removing non-didget characters' do
      expect(p.sms_number_clean).to eq('8885554444')
      p.sms_number = '(888) 555-4444'
      expect(p.sms_number_clean).to eq('8885554444')
      p.sms_number = '(888) 555-4444'
      expect(p.sms_number_clean).to eq('8885554444')
      p.sms_number = '8885554444'
      expect(p.sms_number_clean).to eq('8885554444')
      p.sms_number = '+8885554444'
      expect(p.sms_number_clean).to eq('8885554444')
      p.sms_number = 'asdf8885554444'
      expect(p.sms_number_clean).to eq('8885554444')
      p.sms_number = '8885554444asdf'
      expect(p.sms_number_clean).to eq('8885554444')
      p.sms_number = '888555asdf4444'
      expect(p.sms_number_clean).to eq('8885554444')
      p.sms_number = 'fdas888555asdf4444sdfa'
      expect(p.sms_number_clean).to eq('8885554444')
    end


    it 'returns an email address to send sms' do
      expect(p.sms_email_address).to eq('8885554444@tmomail.net')
      p.sms_number = '4449992222'
      expect(p.sms_email_address).to eq('4449992222@tmomail.net')
    end
  end

  context 'Droid class, with no attributes' do
    let(:d) { Droid.new }
    specify { expect(d.sms_email_domain).to be_blank }
    specify { expect(d.sms_email_address).to be_blank }
    specify { expect(d.sms_number_clean).to be_blank }
  end
end
