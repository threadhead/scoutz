module DashboardHelper
  def unit_well(unit)
    case unit.unit_type
    when 'Cub Scouts'
      'well-cubs'
    when 'Boy Scouts'
      'well-boys'
    else
      ''
    end
  end

  def show_more_amount(all_events, current_events)
    (all_events - current_events) < 5 ? (all_events - current_events) : 5
  end
end
