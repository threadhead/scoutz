class StatusController < ApplicationController
  def ping
    log_level = Rails.logger.level
    Rails.logger.level = Logger::WARN
    render text: 'ok', status: :ok, content_type: Mime::TEXT
    Rails.logger.level = log_level

  end

  def health
    render text: 'ok', status: :ok, content_type: Mime::TEXT
  end
end
