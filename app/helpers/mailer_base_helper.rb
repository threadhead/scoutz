module MailerBaseHelper
  def email_url_with_domain_and_host(url)
    return '' if url.nil?
    (URI.parse(root_url) + url).to_s
  end
end
