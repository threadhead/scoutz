module Scoutlander
  class Unit
    def initialize(options={})
      @name = options[:name]
      @uid = options[:uid]
      @type = options[:type]
      @number = options[:number]
      @city = options[:city]
      @state = options[:state]
      @time_zone = options[:time_zone]
    end

    attr_accessor :name, :uid, :type, :number, :city, :state, :time_zone
  end
end
