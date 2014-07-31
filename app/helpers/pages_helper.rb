module PagesHelper
  def cache_key_for_pages(pages)
    count = pages.count
    max_updated_at = pages.maximum(:updated_at).try(:utc).try(:to_s, :number)
    # "#{pages.first.try(:type).try(:downcase)}s/index-#{count}-#{max_updated_at}"
    "pages/index-#{count}-#{max_updated_at}"
  end

end
