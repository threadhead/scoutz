module DateTimeAttributes
  extend ActiveSupport::Concern

  included do
    # before_validation :attributes_to_datetime
  end

  class_methods do

    # def date_time_attributes
    #   @date_time_attributes || []
    # end


    def date_time_attribute(*attributes)
      # @date_time_attributes = attributes
      # opts = attributes.extract_options!

      attributes.each do |attribute|
        attribute = attribute.to_sym

        define_method("#{attribute}_date") do
          self.send(attribute).strftime("%b %d, %Y") if self.send(attribute).present?
        end

        define_method("#{attribute}_time") do
          self.send(attribute).strftime("%I:%M%P") if self.send(attribute).present?
        end

        define_method("#{attribute}_date=") do |date|
          begin
            self.instance_variable_set("@#{attribute}_date", Date.parse(date).strftime("%Y-%m-%d"))
          rescue ArgumentError
            self.instance_variable_set("@#{attribute}_date", nil)
          end
          self.send("set_#{attribute}_datetime")
        end

        define_method("#{attribute}_time=") do |time|
          begin
            self.instance_variable_set("@#{attribute}_time", Time.parse(time).strftime("%H:%M:%S"))
          rescue ArgumentError
            self.instance_variable_set("@#{attribute}_time", nil)
          end
          self.send("set_#{attribute}_datetime")
        end

        define_method("set_#{attribute}_datetime") do
          date = self.instance_variable_get("@#{attribute}_date")
          time = self.instance_variable_get("@#{attribute}_time")
          begin
            self.send("#{attribute}=", Time.zone.parse("#{date} #{time}"))
          rescue ArgumentError
            self.send("#{attribute}=", nil)
          end
        end

      end

    end
  end

  # def attributes_to_datetime
  #   self.class.date_time_attributes.each do |attribute|
  #     date = self.instance_variable_get("@#{attribute}_date")
  #     time = self.instance_variable_get("@#{attribute}_time")
  #     begin
  #       self.send("#{attribute}=", DateTime.parse("#{date} #{time}"))
  #     rescue ArgumentError
  #       self.send("#{attribute}=", nil)
  #     end
  #   end
  # end
end
