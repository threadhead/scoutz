require 'rails_helper'

RSpec.describe "merit_badges/show", :type => :view do
  before(:each) do
    @merit_badge = assign(:merit_badge, MeritBadge.create!(
      :name => "Name",
      :mb_org_url => "Mb Org Url",
      :mb_org_worksheet_pdf_url => "Mb Org Worksheet Pdf Url",
      :mb_org_worksheet_doc_url => "Mb Org Worksheet Doc Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Mb Org Url/)
    expect(rendered).to match(/Mb Org Worksheet Pdf Url/)
    expect(rendered).to match(/Mb Org Worksheet Doc Url/)
  end
end
