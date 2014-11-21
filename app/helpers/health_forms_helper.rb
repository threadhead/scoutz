module HealthFormsHelper
  def form_date_label(date)
    return '' if date.blank?

    case
    when date > 30.days.from_now
      'label-success'
    when date > 1.day.from_now
      'label-warning'
    else
      'label-danger'
    end
  end

  def cache_key_for_health_form(health_forms)
    count = health_forms.count
    max_updated_at = health_forms.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "health_forms/index-#{count}-#{max_updated_at}"
  end

end
