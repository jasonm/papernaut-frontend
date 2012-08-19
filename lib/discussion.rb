require 'faraday'
require 'json'

class Discussion
  # TODO: If the same article comes in via multiple sources, uniq it
  def self.of_articles(articles)
    articles.map { |article|
      self.for(article).map { |discussion|
        discussion.article = article
        discussion
      }
    }.flatten
  end

  def self.for(article)
    article.identifier_strings.map do |identifier_string|
      for_identifier(identifier_string)
    end.flatten.uniq_by(&:url)
  end

  def self.for_identifier(identifier_string)
    url = "#{JOURNAL_CLUB_ENGINE_URL}/discussions.json?query=#{CGI.escape(identifier_string)}"
    response = get_http(url)
    discussion_hashes = JSON.parse(response.body)
    discussion_hashes.map { |hash| self.new(hash) }
  end

  attr_accessor :article

  def initialize(attributes)
    @attributes = attributes
  end

  def title
    @attributes["title"]
  end

  def url
    @attributes["url"]
  end

  def identifier_strings
    @attributes["identifier_strings"] || []
  end

  private

  def hostname
    Addressable::URI.parse(url).host
  end

  def self.get_http(url)
    Faraday.get(url)
  end
end
