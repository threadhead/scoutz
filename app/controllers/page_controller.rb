class PageController < ApplicationController
  # before_action :auth_and_time_zone

  def landing
    render :landing, layout: 'page'
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
