require 'faraday'
require 'atom'

# TODO: extract to gem, probably improve the public interface
module ZoteroClient
  class User
    attr_reader :uid, :key

    def initialize(uid, key)
      @uid, @key = uid, key
    end

    def items
      Item.for_user(self)
    end
  end

  class Item
    def self.for_user(user)
      url = "https://api.zotero.org/users/#{user.uid}/items?key=#{user.key}&format=atom&content=json"
      response = get_cached_http(url)
      feed = Atom::Feed.load_feed(response.body)
      content_hashes = feed.entries.map { |entry| JSON.parse(entry.content) }
      content_hashes.map { |hash| self.new(hash) }
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def title
      @attributes["title"]
    end

    def url
      @attributes["url"]
    end

    def journal_article?
      @attributes["itemType"] == "journalArticle"
    end

    def identifier_strings
      [
        identifier_for('DOI'),
        identifier_for('ISSN'),
        identifier_for('url'),
        extra_identifier_for('PMID'),
        extra_identifier_for('PMCID')
      ].compact
    end

    private

    def identifier_for(key)
      value = @attributes[key]

      if value.present?
        "#{key.upcase}:#{value}"
      else
        nil
      end
    end

    def extra_identifier_for(key)
      nil
    end

    def self.get_cached_http(url)
      $http_cache ||= {}
      $http_cache[url] ||= Faraday.get(url)
    end
  end
end
