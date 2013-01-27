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
end
