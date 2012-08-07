require 'faraday'
require 'json'

class Discussion
  def self.for(item)
    item.identifier_strings.map do |identifier_string|
      for_identifier(identifier_string)
    end.flatten
  end

  def self.for_identifier(identifier_string)
    url = "#{JOURNAL_CLUB_ENGINE_URL}/discussions.json?query=#{identifier_string}"
    response = get_cached_http(url)
    discussion_hashes = JSON.parse(response.body)
    discussion_hashes.map { |hash| self.new(hash) }
  end

  def initialize(attributes)
    @attributes = attributes
  end

  def title
    host = URI.parse(url).host
    "Discussion on #{host}"
  end

  def url
    @attributes["url"]
  end

  private
  def self.get_cached_http(url)
    $http_cache ||= {}
    $http_cache[url] ||= Faraday.get(url)
  end
end
