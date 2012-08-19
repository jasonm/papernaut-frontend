module EngineStats
  def self.stats
    url = "#{JOURNAL_CLUB_ENGINE_URL}/stats.json"
    json = Faraday.get(url).body
    hash = JSON.parse(json)
  end
end
