require "spec_helper"

describe EmailNotificationsController do
  describe "routing" do

    it "routes to #index" do
      get("/email_notifications").should route_to("email_notifications#index")
    end

    it "routes to #new" do
      get("/email_notifications/new").should route_to("email_notifications#new")
    end

    it "routes to #show" do
      get("/email_notifications/1").should route_to("email_notifications#show", :id => "1")
    end

    it "routes to #edit" do
      get("/email_notifications/1/edit").should route_to("email_notifications#edit", :id => "1")
    end

    it "routes to #create" do
      post("/email_notifications").should route_to("email_notifications#create")
    end

    it "routes to #update" do
      put("/email_notifications/1").should route_to("email_notifications#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/email_notifications/1").should route_to("email_notifications#destroy", :id => "1")
    end

  end
end
