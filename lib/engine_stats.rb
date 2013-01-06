module EngineStats
  def self.stats
    url = "#{PAPERNAUT_ENGINE_URL}/stats.json"
    json = Faraday.get(url).body
    hash = JSON.parse(json)
  rescue JSON::ParserError, Faraday::Error::ConnectionFailed => e
    false
  end
end
