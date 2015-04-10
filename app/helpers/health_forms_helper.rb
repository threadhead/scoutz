module HealthFormsHelper
  def form_date_label(date)
    return 'label-default' if date.blank?

    case
    when date > 30.days.from_now
      'label-success'
    when date >= Date.today
      'label-warning'
    else
      'label-danger'
    end
  end

  def cache_key_for_health_form(health_forms)
    # count = health_forms.size
    # max_updated_at = health_forms.maximum(:updated_at).try(:utc).try(:to_s, :number)
    count_max = [health_forms.size, health_forms.maximum(:updated_at)].map(&:to_i).join('-')
    "health_forms/index-#{count_max}"
  end

end
