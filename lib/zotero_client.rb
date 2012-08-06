require 'faraday'
require 'atom'

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
      response = Faraday.get(url)
      feed = Atom::Feed.load_feed(response.body)
      content_hashes = feed.entries.map { |entry| JSON.parse(entry.content) }
      content_hashes.map { |hash| self.new(hash) }
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def [](key)
      @attributes[key]
    end
  end
end
