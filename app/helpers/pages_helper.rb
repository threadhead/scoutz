module PagesHelper
  def cache_key_for_pages(pages)
    # count = pages.size
    # max_updated_at = pages.maximum(:updated_at).try(:utc).try(:to_s, :number)
    # "#{pages.first.try(:type).try(:downcase)}s/index-#{count}-#{max_updated_at}"
    count_max = [pages.size, pages.maximum(:updated_at)].map(&:to_i).join('-')
    "pages/index-#{count_max}"
  end

end
