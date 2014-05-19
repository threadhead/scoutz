module Scoutlander
  module Datum

    class Event
      def initialize(options={})
        atr = [ :inspected,
                :sl_url,
                :sl_uid,
                :sl_profile,
                :kind,
                :kind_sub_units,
                :name,
                :organizer_profile,
                :send_reminders,
                :start_at,
                :end_at,
                :signup_required,
                :signup_deadline,
                :location_name,
                :location_address1,
                :location_address2,
                :location_city,
                :location_state,
                :location_zip_code,
                :location_url,
                :attire,
                :message,
                :fees
              ]

        atr.each do |arg|
          self.class.class_eval("def #{arg};@#{arg};end")
          self.class.class_eval("def #{arg}=(val);@#{arg}=val;end")

          self.instance_variable_set("@#{arg}".to_sym, options[arg])
        end

        # atr.each { |arg| puts "#{arg}: #{self.instance_variable_get("@#{arg}".to_sym)}" }
        # puts self.class.instance_methods - Object.instance_methods
        @inspected = false if @inspected.nil?
      end

    end
  end
end
