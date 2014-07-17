# require 'spec_helper'

# RSpec.describe "merit_badges/edit", :type => :view do
#   before(:each) do
#     @merit_badge = assign(:merit_badge, MeritBadge.create!(
#       :name => "MyString",
#       :mb_org_url => "MyString",
#       :mb_org_worksheet_pdf_url => "MyString",
#       :mb_org_worksheet_doc_url => "MyString"
#     ))
#   end

#   it "renders the edit merit_badge form" do
#     render

#     assert_select "form[action=?][method=?]", merit_badge_path(@merit_badge), "post" do

#       assert_select "input#merit_badge_name[name=?]", "merit_badge[name]"

#       assert_select "input#merit_badge_mb_org_url[name=?]", "merit_badge[mb_org_url]"

#       assert_select "input#merit_badge_mb_org_worksheet_pdf_url[name=?]", "merit_badge[mb_org_worksheet_pdf_url]"

#       assert_select "input#merit_badge_mb_org_worksheet_doc_url[name=?]", "merit_badge[mb_org_worksheet_doc_url]"
#     end
#   end
# end
