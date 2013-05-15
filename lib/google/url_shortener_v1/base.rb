require 'rest-client'

module Google
  module UrlShortenerV1
    module Base
      BASE_URL = "https://www.googleapis.com/urlshortener/v1/url"
      REQUEST_HEADERS = { content_type: :json, accept: :json }


      def self.shorten(long_url)
        response = ::RestClient.post(BASE_URL, post_params(long_url), REQUEST_HEADERS)
        JSON.parse(response)['id']
      end

      def self.post_params(long_url)
        {longUrl: long_url}.merge({key: api_key}).to_json
      end

      def self.api_key
        ENV['GOOGLE_API_KEY']
      end

    end
  end
end
