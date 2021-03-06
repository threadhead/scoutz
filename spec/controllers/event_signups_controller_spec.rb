# require 'rails_helper'

# # This spec was generated by rspec-rails when you ran the scaffold generator.
# # It demonstrates how one might use RSpec to specify the controller code that
# # was generated by Rails when you ran the scaffold generator.
# #
# # It assumes that the implementation code is generated by the rails scaffold
# # generator.  If you are using any extension libraries to generate different
# # controller code, this generated spec may or may not pass.
# #
# # It only uses APIs available in rails and/or rspec-rails.  There are a number
# # of tools you can use to make these specs even more expressive, but we're
# # sticking to rails and rspec-rails APIs to keep things simple and stable.
# #
# # Compared to earlier versions of this generator, there is very limited use of
# # stubs and message expectations in this spec.  Stubs are only used when there
# # is no simpler way to get a handle on the object needed for the example.
# # Message expectations are only used when there is no simpler way to specify
# # that an instance is receiving a specific message.

# describe EventSignupsController do

#   # This should return the minimal set of attributes required to create a valid
#   # EventSignup. As you add validations to EventSignup, be sure to
#   # update the return value of this method accordingly.
#   def valid_attributes
#     { "event" => "" }
#   end

#   # This should return the minimal set of values that should be in the session
#   # in order to pass any filters (e.g. authentication) defined in
#   # EventSignupsController. Be sure to keep this updated too.
#   def valid_session
#     {}
#   end

#   describe "GET index" do
#     it "assigns all event_signups as @event_signups" do
#       event_signup = EventSignup.create! valid_attributes
#       get :index, {}, valid_session
#       assigns(:event_signups).should eq([event_signup])
#     end
#   end

#   describe "GET show" do
#     it "assigns the requested event_signup as @event_signup" do
#       event_signup = EventSignup.create! valid_attributes
#       get :show, {:id => event_signup.to_param}, valid_session
#       assigns(:event_signup).should eq(event_signup)
#     end
#   end

#   describe "GET new" do
#     it "assigns a new event_signup as @event_signup" do
#       get :new, {}, valid_session
#       assigns(:event_signup).should be_a_new(EventSignup)
#     end
#   end

#   describe "GET edit" do
#     it "assigns the requested event_signup as @event_signup" do
#       event_signup = EventSignup.create! valid_attributes
#       get :edit, {:id => event_signup.to_param}, valid_session
#       assigns(:event_signup).should eq(event_signup)
#     end
#   end

#   describe "POST create" do
#     describe "with valid params" do
#       it "creates a new EventSignup" do
#         expect {
#           post :create, {:event_signup => valid_attributes}, valid_session
#         }.to change(EventSignup, :count).by(1)
#       end

#       it "assigns a newly created event_signup as @event_signup" do
#         post :create, {:event_signup => valid_attributes}, valid_session
#         assigns(:event_signup).should be_a(EventSignup)
#         assigns(:event_signup).should be_persisted
#       end

#       it "redirects to the created event_signup" do
#         post :create, {:event_signup => valid_attributes}, valid_session
#         response.should redirect_to(EventSignup.last)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns a newly created but unsaved event_signup as @event_signup" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         EventSignup.any_instance.stub(:save).and_return(false)
#         post :create, {:event_signup => { "event" => "invalid value" }}, valid_session
#         assigns(:event_signup).should be_a_new(EventSignup)
#       end

#       it "re-renders the 'new' template" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         EventSignup.any_instance.stub(:save).and_return(false)
#         post :create, {:event_signup => { "event" => "invalid value" }}, valid_session
#         response.should render_template("new")
#       end
#     end
#   end

#   describe "PUT update" do
#     describe "with valid params" do
#       it "updates the requested event_signup" do
#         event_signup = EventSignup.create! valid_attributes
#         # Assuming there are no other event_signups in the database, this
#         # specifies that the EventSignup created on the previous line
#         # receives the :update_attributes message with whatever params are
#         # submitted in the request.
#         EventSignup.any_instance.should_receive(:update_attributes).with({ "event" => "" })
#         put :update, {:id => event_signup.to_param, :event_signup => { "event" => "" }}, valid_session
#       end

#       it "assigns the requested event_signup as @event_signup" do
#         event_signup = EventSignup.create! valid_attributes
#         put :update, {:id => event_signup.to_param, :event_signup => valid_attributes}, valid_session
#         assigns(:event_signup).should eq(event_signup)
#       end

#       it "redirects to the event_signup" do
#         event_signup = EventSignup.create! valid_attributes
#         put :update, {:id => event_signup.to_param, :event_signup => valid_attributes}, valid_session
#         response.should redirect_to(event_signup)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns the event_signup as @event_signup" do
#         event_signup = EventSignup.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         EventSignup.any_instance.stub(:save).and_return(false)
#         put :update, {:id => event_signup.to_param, :event_signup => { "event" => "invalid value" }}, valid_session
#         assigns(:event_signup).should eq(event_signup)
#       end

#       it "re-renders the 'edit' template" do
#         event_signup = EventSignup.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         EventSignup.any_instance.stub(:save).and_return(false)
#         put :update, {:id => event_signup.to_param, :event_signup => { "event" => "invalid value" }}, valid_session
#         response.should render_template("edit")
#       end
#     end
#   end

#   describe "DELETE destroy" do
#     it "destroys the requested event_signup" do
#       event_signup = EventSignup.create! valid_attributes
#       expect {
#         delete :destroy, {:id => event_signup.to_param}, valid_session
#       }.to change(EventSignup, :count).by(-1)
#     end

#     it "redirects to the event_signups list" do
#       event_signup = EventSignup.create! valid_attributes
#       delete :destroy, {:id => event_signup.to_param}, valid_session
#       response.should redirect_to(event_signups_url)
#     end
#   end

# end
