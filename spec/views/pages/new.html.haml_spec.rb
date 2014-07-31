# require 'rails_helper'

# RSpec.describe "pages/new", :type => :view do
#   before(:each) do
#     assign(:page, Page.new(
#       :postion => 1,
#       :title => "MyString",
#       :body => "MyText",
#       :unit => nil,
#       :user => nil,
#       :public => false
#     ))
#   end

#   it "renders new page form" do
#     render

#     assert_select "form[action=?][method=?]", pages_path, "post" do

#       assert_select "input#page_postion[name=?]", "page[postion]"

#       assert_select "input#page_title[name=?]", "page[title]"

#       assert_select "textarea#page_body[name=?]", "page[body]"

#       assert_select "input#page_unit_id[name=?]", "page[unit_id]"

#       assert_select "input#page_user_id[name=?]", "page[user_id]"

#       assert_select "input#page_public[name=?]", "page[public]"
#     end
#   end
# end
