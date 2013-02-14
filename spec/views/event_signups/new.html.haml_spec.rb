require 'spec_helper'

describe "event_signups/new" do
  before(:each) do
    assign(:event_signup, stub_model(EventSignup,
      :event => nil,
      :scouts => "MyString",
      :adults => "MyString",
      :siblings => "MyString",
      :comment => "MyText"
    ).as_new_record)
  end

  it "renders new event_signup form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => event_signups_path, :method => "post" do
      assert_select "input#event_signup_event", :name => "event_signup[event]"
      assert_select "input#event_signup_scouts", :name => "event_signup[scouts]"
      assert_select "input#event_signup_adults", :name => "event_signup[adults]"
      assert_select "input#event_signup_siblings", :name => "event_signup[siblings]"
      assert_select "textarea#event_signup_comment", :name => "event_signup[comment]"
    end
  end
end
