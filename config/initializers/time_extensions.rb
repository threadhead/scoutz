# this is an extension of Ryan McGeary's solution, specifically for Rails.
# Note the use of utc, which is necessary to keep Rails time zone stuff happy.
# put this in config/initializers/time_extensions

require 'rubygems'
require 'active_support'

module TimeExtensions
  # %w[ round floor ceil ].each do |_method|
  #   define_method _method do |*args|
  #     seconds = args.first || 60
  #     Time.at((self.to_f / seconds).send(_method) * seconds).utc.in_time_zone(self.time_zone)
  #   end
  # end

  def to_next_hour
    Time.zone.local(self.year, self.month, self.day, self.hour, 0, 0).advance(hours: 1)
  end

  def to_next_30_minutes
    Time.zone.local(self.year, self.month, self.day, self.hour, self.min/30*30, 0).advance(minutes: 30)
  end
end

ActiveSupport::TimeWithZone.send :include, TimeExtensions
