class PageController < ApplicationController
  before_filter :auth_and_time_zone

  def landing
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
