# require 'spec_helper'

# RSpec.describe "merit_badges/index", :type => :view do
#   before(:each) do
#     assign(:merit_badges, [
#       MeritBadge.create!(
#         :name => "Name",
#         :mb_org_url => "Mb Org Url",
#         :mb_org_worksheet_pdf_url => "Mb Org Worksheet Pdf Url",
#         :mb_org_worksheet_doc_url => "Mb Org Worksheet Doc Url"
#       ),
#       MeritBadge.create!(
#         :name => "Name",
#         :mb_org_url => "Mb Org Url",
#         :mb_org_worksheet_pdf_url => "Mb Org Worksheet Pdf Url",
#         :mb_org_worksheet_doc_url => "Mb Org Worksheet Doc Url"
#       )
#     ])
#   end

#   it "renders a list of merit_badges" do
#     render
#     assert_select "tr>td", :text => "Name".to_s, :count => 2
#     assert_select "tr>td", :text => "Mb Org Url".to_s, :count => 2
#     assert_select "tr>td", :text => "Mb Org Worksheet Pdf Url".to_s, :count => 2
#     assert_select "tr>td", :text => "Mb Org Worksheet Doc Url".to_s, :count => 2
#   end
# end
