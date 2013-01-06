module EngineStats
  def self.stats
    url = "#{PAPERNAUT_ENGINE_URL}/stats.json"
    json = Faraday.get(url).body
    hash = JSON.parse(json)
  end
end
