# this class is used to create datetime and datetime range strings that approximate how Google displays datetimes

module Google
  class TimeDisplay
    def initialize(time_start, time_end=nil)
      @time_start = time_start
      @time_end = time_end
      @abbr_month = false
      @show_weekday = true
      @abbr_weekday = true
    end

    def to_s
      if no_ending_time?
        formatted_s(@time_start)

      elsif start_end_on_same_day?
        "#{formatted_s(@time_start)} - #{time_only(@time_end)}"

      else
        "#{formatted_s(@time_start)} - #{formatted_s(@time_end)}"
      end
    end





    def formatted_s(t)
      format = "#{weekday_format}#{month_format} %-d, #{year_format(t)}"
      format << time_format

      t.strftime format
    end


    def time_only(t)
      t.strftime time_format
    end


    def time_format
      if display_minutes?
        "%-l:%M%P"
      else
        "%-l%P"
      end
    end

    def month_format
      @abbr_month ? '%b' : '%B'
    end

    def year_format(t)
      t.year == Time.zone.now.year ? '' : '%Y, '
    end

    def weekday_format
      if @show_weekday
        @abbr_weekday ? '%a, ' : '%A, '
      else
        ''
      end
    end





    def abbr_month(val=true)
      @abbr_month = val
      self
    end


    def show_weekday(val=true)
      @show_weekday = val
      self
    end

    def hide_weekday
      @show_weekday = false
      self
    end

    def abbr_weekday(val=true)
      @abbr_weekday = val
      self
    end





    def no_ending_time?
      @time_end.nil?
    end

    def start_end_on_same_day?
      @time_start.year == @time_end.year &&
      @time_start.month == @time_end.month &&
      @time_start.day == @time_end.day
    end

    def display_minutes?
      if @time_end.nil?
        @time_start.min != 0
      else
        @time_start.min != 0 || @time_end.min != 0
      end
    end





  end
end
