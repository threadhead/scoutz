module ApplicationHelper
  def display_flash_type?(name)
    allowed_names = [:notice, :msg_ok, :error, :alert, :info, :warning]
    name && allowed_names.include?(name)
  end

  def flash_method_class(name)
    case name
    when :notice
      'alert-success'
    when :msg_ok, :info
      'alert-info'
    else
      'alert-error'
    end
  end

  def flash_method_icon(name)
    case name
      when :notice
        'icon-ok-sign'
      when :msg_ok, :info
        'icon-info-sign'
      else
        'icon-warning-sign'
      end
  end

end
