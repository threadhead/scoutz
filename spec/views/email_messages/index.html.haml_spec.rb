# require 'rails_helper'

# describe "email_messages/index" do
#   before(:each) do
#     assign(:email_messages, [
#       stub_model(EmailMessage,
#         :user_id => 1,
#         :message => "MyText",
#         :subject => "Subject"
#       ),
#       stub_model(EmailMessage,
#         :user_id => 1,
#         :message => "MyText",
#         :subject => "Subject"
#       )
#     ])
#   end

#   it "renders a list of email_messages" do
#     render
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "tr>td", :text => 1.to_s, :count => 2
#     assert_select "tr>td", :text => "MyText".to_s, :count => 2
#     assert_select "tr>td", :text => "Subject".to_s, :count => 2
#   end
# end
