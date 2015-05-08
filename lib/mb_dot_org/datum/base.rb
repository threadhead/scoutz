module MbDotOrg
  module Datum
    class Base
      attr_accessor :attributes

      def create_setters_getters_instance_variables(options)
        @attributes.each do |arg|
          self.class.class_eval("def #{arg};@#{arg};end")
          self.class.class_eval("def #{arg}=(val);@#{arg}=val;end")

          self.instance_variable_set("@#{arg}".to_sym, options[arg])
        end

        @inspected = false if @inspected.nil?
      end

      def to_params_without(*args)
        atr = delete_attributes(*args)
        # return a hash of all attributes and values
        h = Hash.new
        atr.each do |a|
          val = send(a)
          h[a.to_sym] = val unless val.nil?
        end
        h
      end

      # return a duplicated array with elements deleted
      def delete_attributes(*args)
        @attributes.dup.delete_if { |a| args.include?(a) }
      end

    end
  end
end
