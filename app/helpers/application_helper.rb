module ApplicationHelper
  def display_flash_type?(name)
    allowed_names = ['notice', 'msg_ok', 'error', 'alert', 'info', 'warning']
    name && allowed_names.include?(name.to_s)
  end

  def flash_method_class(name)
    case name.to_s
    when 'notice'
      'alert-success'
    when 'msg_ok', 'info', 'alert'
      'alert-info'
    when 'error', 'warning'
      'alert-danger'
    else
      ''
    end
  end

  def flash_method_icon(name)
    case name.to_s
      when 'notice'
        'fa-check-circle'
      when 'msg_ok', 'info', 'alert'
        'fa-info-circle'
      when 'error', 'warning'
        'fa-exclamation-triangle'
      else
        ''
      end
  end

  def shorten_url(url)
    Google::UrlShortenerV1::Base.shorten(url)
  end

  def user_picture_url(user)
    if user.picture.present?
      image_url user.picture.thumb.url
    else
      image_url 'default_user_thumb.jpg'
    end
  end

  def table_scout_panel(unit)
    @unit.unit_type.gsub(/\s/, '').underscore.dasherize
  end
end
