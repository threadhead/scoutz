module SmsNumber
  extend ActiveSupport::Concern

  included do
    validate :sms_number_length
    def sms_number_length
      return true if sms_number.blank?
      errors.add(:sms_number, 'must be 10 digits') unless sms_number_clean.length == 10
    end
  end

  class_methods do
    def sms_providers
      [
        'AT&T',
        'Verizon',
        'T-Mobile',
        'Sprint',
        'Virgin Mobile',
        'Tracfone',
        'Metro PCS',
        'Boost Mobile',
        'Cricket',
        'Nextel',
        'Alltel',
        'Qwest',
        'US Cellular'
      ]
    end
  end

  def sms_email_domain
    return '' unless self.respond_to?(:sms_provider)
    case sms_provider
    when 'AT&T' then 'txt.att.net'
    when 'Verizon' then 'vtext.com'
    when 'T-Mobile' then 'tmomail.net'
    when 'Sprint' then 'messaging.sprintpcs.com'
    when 'Virgin Mobile' then 'vmobl.com'
    when 'Tracfone' then 'mmst5.tracfone.com'
    when 'Metro PCS' then 'mymetropcs.com'
    when 'Boost Mobile' then 'myboostmobile.com'
    when 'Cricket' then 'sms.mycricket.com'
    when 'Nextel' then 'messaging.nextel.com'
    when 'Alltel' then 'message.alltel.com'
    when 'Qwest' then 'qwestmp.com'
    when 'US Cellular' then 'email.uscc.net'
    else
      ''
    end
  end

  def sms_email_address
    return '' if !self.respond_to?(:sms_number) || sms_number.blank?
    "#{sms_number_clean}@#{sms_email_domain}"
  end

  def sms_number_clean
    return '' if !self.respond_to?(:sms_number) || sms_number.blank?
    sms_number.gsub(/[^\d]/, '')
  end

  private

end
