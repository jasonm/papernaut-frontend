require 'faraday'

class Doi
  def initialize(doi)
    @doi = doi
  end

  def exists?
    response.status == 303
  end

  private

  def response
    http.head do |req|
      req.url "/#{@doi}"
    end
  end

  def http
    Faraday.new(:url => 'http://dx.doi.org')
  end
end
