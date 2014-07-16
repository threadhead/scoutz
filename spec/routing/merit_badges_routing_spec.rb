require "rails_helper"

RSpec.describe MeritBadgesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/merit_badges").to route_to("merit_badges#index")
    end

    it "routes to #new" do
      expect(:get => "/merit_badges/new").to route_to("merit_badges#new")
    end

    it "routes to #show" do
      expect(:get => "/merit_badges/1").to route_to("merit_badges#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/merit_badges/1/edit").to route_to("merit_badges#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/merit_badges").to route_to("merit_badges#create")
    end

    it "routes to #update" do
      expect(:put => "/merit_badges/1").to route_to("merit_badges#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/merit_badges/1").to route_to("merit_badges#destroy", :id => "1")
    end

  end
end
