# require 'rails_helper'

# RSpec.describe "pages/index", :type => :view do
#   before(:each) do
#     assign(:pages, [
#       Page.create!(
#         :postion => 1,
#         :title => "Title",
#         :body => "MyText",
#         :unit => nil,
#         :user => nil,
#         :public => false
#       ),
#       Page.create!(
#         :postion => 1,
#         :title => "Title",
#         :body => "MyText",
#         :unit => nil,
#         :user => nil,
#         :public => false
#       )
#     ])
#   end

#   it "renders a list of pages" do
#     render
#     assert_select "tr>td", :text => 1.to_s, :count => 2
#     assert_select "tr>td", :text => "Title".to_s, :count => 2
#     assert_select "tr>td", :text => "MyText".to_s, :count => 2
#     assert_select "tr>td", :text => nil.to_s, :count => 2
#     assert_select "tr>td", :text => nil.to_s, :count => 2
#     assert_select "tr>td", :text => false.to_s, :count => 2
#   end
# end
