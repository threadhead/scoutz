module Notifiers
  class SmsSender
      def initialize(recipient_user, options={})
        @recipient_user = recipient_user
        @force_send = options[:force_send] if options[:force_send]
      end


      def send_message(message)
        if recipient_has_number && ( @force_send || sms_number_verified )
          client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])

          client.account.sms.messages.create(
            from: TWILIO_CONFIG['from'],
            to: @recipient_user.sms_number,
            body: message
          )
        end
      end


      def recipient_has_number
        !@recipient_user.sms_number.blank?
      end

      def sms_number_verified
        unless @recipient_user.sms_number_verified
          SmsUserMailer.delay.remind_verify(@recipient_user.id)
        end
        @recipient_user.sms_number_verified
      end

  end
end
