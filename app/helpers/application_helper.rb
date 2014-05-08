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
    case name
      when :notice
        'icon-ok-sign'
      when :msg_ok, :info, :alert
        'icon-info-sign'
      when :error, :warning
        'icon-warning-sign'
      else
        ''
      end
  end

end
