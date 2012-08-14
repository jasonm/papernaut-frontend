require 'faraday'
require 'atom'

# TODO: extract to gem, probably improve the public interface
module MendeleyClient
  class User
    attr_reader :uid, :token, :secret

    def initialize(uid, token, secret)
      @uid, @token, @secret = uid, token, secret
    end

    def items
      document_ids.map do |document_id|
        document_hash = fetch_document_hash(document_id)
        Item.new(document_hash)
      end
    end

    private

    #TODO: paginate
    def document_ids
      library = get_oauth_json('http://api.mendeley.com/oapi/library/')
      library['document_ids']
    end

    def fetch_document_hash(document_id)
      get_oauth_json("http://api.mendeley.com/oapi/library/documents/#{document_id}/")
    end

    #TODO: rate limit?
    # http://apidocs.mendeley.com/home/rate-limiting
    def get_oauth_json(url)
      response = oauth_access_token.request(:get, url)

      if response.code != "200"
        raise "Mendeley JSON API request via OAuth returned non-200:\n" + 
              "Code: #{response.code}\n" +
              "Body:\n#{response.body}"
      end

      JSON.parse(response.body)
    end

    def oauth_access_token
      OAuth::AccessToken.from_hash(oauth_consumer, {
        :oauth_token => @token,
        :oauth_token_secret => @secret
      })
    end

    def oauth_consumer
      OAuth::Consumer.new(MENDELEY_OAUTH_CONSUMER_KEY, MENDELEY_OAUTH_CONSUMER_SECRET, {
        :site => "https://api.mendeley.com"
      })
    end
  end

  class Item
    def initialize(attributes)
      @attributes = attributes
    end

    def title
      @attributes['title']
    end

    def url
      @attributes['url']
    end

    def journal_article?
      @attributes['type'] == 'Journal Article'
    end

    def identifier_strings
      [url_identifier, identifier('doi'), identifier('pmid')].compact
    end

    private

    def url_identifier
      "URL:#{url}" if url
    end

    def identifier(key)
      identifiers = @attributes['identifiers']

      return if identifiers == []
      return unless identifiers.has_key?(key)

      "#{key.upcase}:#{identifiers[key]}"
    end
  end
end
