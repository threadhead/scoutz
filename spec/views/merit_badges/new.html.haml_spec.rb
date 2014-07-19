# require 'rails_helper'

# RSpec.describe "merit_badges/new", :type => :view do
#   before(:each) do
#     assign(:merit_badge, MeritBadge.new(
#       :name => "MyString",
#       :mb_org_url => "MyString",
#       :mb_org_worksheet_pdf_url => "MyString",
#       :mb_org_worksheet_doc_url => "MyString"
#     ))
#   end

#   it "renders new merit_badge form" do
#     render

#     assert_select "form[action=?][method=?]", merit_badges_path, "post" do

#       assert_select "input#merit_badge_name[name=?]", "merit_badge[name]"

#       assert_select "input#merit_badge_mb_org_url[name=?]", "merit_badge[mb_org_url]"

#       assert_select "input#merit_badge_mb_org_worksheet_pdf_url[name=?]", "merit_badge[mb_org_worksheet_pdf_url]"

#       assert_select "input#merit_badge_mb_org_worksheet_doc_url[name=?]", "merit_badge[mb_org_worksheet_doc_url]"
#     end
#   end
# end
