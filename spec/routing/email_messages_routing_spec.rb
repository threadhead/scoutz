require "spec_helper"

describe EmailMessagesController do
  describe "routing" do

    it "routes to #index" do
      get("/email_messages").should route_to("email_messages#index")
    end

    it "routes to #new" do
      get("/email_messages/new").should route_to("email_messages#new")
    end

    it "routes to #show" do
      get("/email_messages/1").should route_to("email_messages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/email_messages/1/edit").should route_to("email_messages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/email_messages").should route_to("email_messages#create")
    end

    it "routes to #update" do
      put("/email_messages/1").should route_to("email_messages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/email_messages/1").should route_to("email_messages#destroy", :id => "1")
    end

  end
end
