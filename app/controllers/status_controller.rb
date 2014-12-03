class StatusController < ApplicationController
  def ping
    render text: 'ok', status: :ok, content_type: Mime::TEXT
  end

  def health
    render text: 'ok', status: :ok, content_type: Mime::TEXT
  end
end
