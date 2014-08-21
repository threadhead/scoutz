class MetaSearchController < ApplicationController
  def index
    events = Event.limit(10)
    render json: events
  end
end
