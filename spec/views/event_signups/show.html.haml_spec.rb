require 'spec_helper'

describe "event_signups/show" do
  before(:each) do
    @event_signup = assign(:event_signup, stub_model(EventSignup,
      :event => nil,
      :scouts => "Scouts",
      :adults => "Adults",
      :siblings => "Siblings",
      :comment => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Scouts/)
    rendered.should match(/Adults/)
    rendered.should match(/Siblings/)
    rendered.should match(/MyText/)
  end
end
