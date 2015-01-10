class PageController < ApplicationController
  # before_action :auth_and_time_zone

  def landing
    # important, this will no account for changes in the page layout. must change
    #   etag value if page layout is changed.
    # fresh_when File.mtime("#{Rails.root}/app/views/page/landing.html.haml", etag: 1)
    render :landing, layout: 'page'
  end

  def redirect_to_dashboard
    auth_and_time_zone
    redirect_to unit_events_url(@unit)
  end

  def terms_of_service
  end

  def privacy
  end

  def contact
  end

  def about
  end
end
