class StatusController < ActionController::Metal
  def ping
    # log_level = Rails.logger.level
    # Rails.logger.level = Logger::WARN
    # render text: 'ok', status: :ok, content_type: Mime::TEXT
    # Rails.logger.level = log_level
    self.status = :ok
    self.content_type = Mime::TEXT
    self.response_body = 'ok'
  end

  def health
    # render text: 'ok', status: :ok, content_type: Mime::TEXT
    self.status = :ok
    self.content_type = Mime::TEXT
    self.response_body = 'ok'
  end
end
