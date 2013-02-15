# require 'spec_helper'

# describe "event_signups/edit" do
#   before(:each) do
#     @event_signup = assign(:event_signup, stub_model(EventSignup,
#       :event => nil,
#       :scouts => "MyString",
#       :adults => "MyString",
#       :siblings => "MyString",
#       :comment => "MyText"
#     ))
#   end

#   it "renders the edit event_signup form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => event_signups_path(@event_signup), :method => "post" do
#       assert_select "input#event_signup_event", :name => "event_signup[event]"
#       assert_select "input#event_signup_scouts", :name => "event_signup[scouts]"
#       assert_select "input#event_signup_adults", :name => "event_signup[adults]"
#       assert_select "input#event_signup_siblings", :name => "event_signup[siblings]"
#       assert_select "textarea#event_signup_comment", :name => "event_signup[comment]"
#     end
#   end
# end
