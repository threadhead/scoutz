class MetaSearchController < ApplicationController
  def index
    events = Event.meta_search(unit_scope: Unit.find(3), keywords: params[:term]).limit(5)
    scouts = Scout.meta_search(unit_scope: Unit.find(3), keywords: params[:term]).limit(5)
    adults = Adult.meta_search(unit_scope: Unit.find(3), keywords: params[:term]).limit(5)

    # r_json = Event.meta_search_json(events) << Scout.meta_search_json(scouts, unit_scope: Unit.find(3))
    all_rec = events + adults + scouts
    r_json = all_rec.map{ |resource| resource.meta_search_json(unit_scope: Unit.find(3)) }.to_json

    render json: r_json
  end
end
