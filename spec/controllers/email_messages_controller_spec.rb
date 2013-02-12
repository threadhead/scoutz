# require 'spec_helper'

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

# describe EmailMessagesController do

#   # This should return the minimal set of attributes required to create a valid
#   # EmailMessage. As you add validations to EmailMessage, be sure to
#   # update the return value of this method accordingly.
#   def valid_attributes
#     FactoryGirl.attributes_for(:email_message)
#   end

#   # This should return the minimal set of values that should be in the session
#   # in order to pass any filters (e.g. authentication) defined in
#   # EmailMessagesController. Be sure to keep this updated too.
#   def valid_session
#     {}
#   end

#   describe "GET index" do
#     it "assigns all email_messages as @email_messages" do
#       email_message = EmailMessage.create! valid_attributes
#       get :index, {}, valid_session
#       assigns(:email_messages).should eq([email_message])
#     end
#   end

#   describe "GET show" do
#     it "assigns the requested email_message as @email_message" do
#       email_message = EmailMessage.create! valid_attributes
#       get :show, {:id => email_message.to_param}, valid_session
#       assigns(:email_message).should eq(email_message)
#     end
#   end

#   describe "GET new" do
#     it "assigns a new email_message as @email_message" do
#       get :new, {}, valid_session
#       assigns(:email_message).should be_a_new(EmailMessage)
#     end
#   end

#   describe "GET edit" do
#     it "assigns the requested email_message as @email_message" do
#       email_message = EmailMessage.create! valid_attributes
#       get :edit, {:id => email_message.to_param}, valid_session
#       assigns(:email_message).should eq(email_message)
#     end
#   end

#   describe "POST create" do
#     describe "with valid params" do
#       it "creates a new EmailMessage" do
#         expect {
#           post :create, {:email_message => valid_attributes}, valid_session
#         }.to change(EmailMessage, :count).by(1)
#       end

#       it "assigns a newly created email_message as @email_message" do
#         post :create, {:email_message => valid_attributes}, valid_session
#         assigns(:email_message).should be_a(EmailMessage)
#         assigns(:email_message).should be_persisted
#       end

#       it "redirects to the created email_message" do
#         post :create, {:email_message => valid_attributes}, valid_session
#         response.should redirect_to(EmailMessage.last)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns a newly created but unsaved email_message as @email_message" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         EmailMessage.any_instance.stub(:save).and_return(false)
#         post :create, {:email_message => { "user_id" => "invalid value" }}, valid_session
#         assigns(:email_message).should be_a_new(EmailMessage)
#       end

#       it "re-renders the 'new' template" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         EmailMessage.any_instance.stub(:save).and_return(false)
#         post :create, {:email_message => { "user_id" => "invalid value" }}, valid_session
#         response.should render_template("new")
#       end
#     end
#   end

#   describe "PUT update" do
#     describe "with valid params" do
#       it "updates the requested email_message" do
#         email_message = EmailMessage.create! valid_attributes
#         # Assuming there are no other email_messages in the database, this
#         # specifies that the EmailMessage created on the previous line
#         # receives the :update_attributes message with whatever params are
#         # submitted in the request.
#         EmailMessage.any_instance.should_receive(:update_attributes).with({ "user_id" => "1" })
#         put :update, {:id => email_message.to_param, :email_message => { "user_id" => "1" }}, valid_session
#       end

#       it "assigns the requested email_message as @email_message" do
#         email_message = EmailMessage.create! valid_attributes
#         put :update, {:id => email_message.to_param, :email_message => valid_attributes}, valid_session
#         assigns(:email_message).should eq(email_message)
#       end

#       it "redirects to the email_message" do
#         email_message = EmailMessage.create! valid_attributes
#         put :update, {:id => email_message.to_param, :email_message => valid_attributes}, valid_session
#         response.should redirect_to(email_message)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns the email_message as @email_message" do
#         email_message = EmailMessage.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         EmailMessage.any_instance.stub(:save).and_return(false)
#         put :update, {:id => email_message.to_param, :email_message => { "user_id" => "invalid value" }}, valid_session
#         assigns(:email_message).should eq(email_message)
#       end

#       it "re-renders the 'edit' template" do
#         email_message = EmailMessage.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         EmailMessage.any_instance.stub(:save).and_return(false)
#         put :update, {:id => email_message.to_param, :email_message => { "user_id" => "invalid value" }}, valid_session
#         response.should render_template("edit")
#       end
#     end
#   end

#   describe "DELETE destroy" do
#     it "destroys the requested email_message" do
#       email_message = EmailMessage.create! valid_attributes
#       expect {
#         delete :destroy, {:id => email_message.to_param}, valid_session
#       }.to change(EmailMessage, :count).by(-1)
#     end

#     it "redirects to the email_messages list" do
#       email_message = EmailMessage.create! valid_attributes
#       delete :destroy, {:id => email_message.to_param}, valid_session
#       response.should redirect_to(email_messages_url)
#     end
#   end

# end
