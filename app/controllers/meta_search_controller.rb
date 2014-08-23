class MetaSearchController < ApplicationController
  def index
    unit = Unit.find(params[:unit_id])

    events = Event.meta_search(unit_scope: unit, keywords: params[:term]).limit(5)
    scouts = Scout.meta_search(unit_scope: unit, keywords: params[:term]).limit(5)
    adults = Adult.meta_search(unit_scope: unit, keywords: params[:term]).limit(5)
    all_rec = events + adults + scouts

    r_json = all_rec.map{ |resource| resource.meta_search_json(unit_scope: unit) }.to_json

    render json: r_json
  end
end
