module HealthFormsHelper
  def form_date_label(date)
    return '' if date.blank?

    case
    when date > 30.days.from_now
      'label-success'
    when date > 15.days.from_now
      'label-warning'
    when date < 15.days.from_now
      'label-danger'
    end
  end
end
