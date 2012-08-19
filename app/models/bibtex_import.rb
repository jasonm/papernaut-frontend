require 'bibtex'

class BibtexImport
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :file, :bibtex_source, :user

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def file=(new_file)
    @file = new_file
    @bibtex_source = new_file.read
  end

  def new_articles
    bibliography.data.map do |data|
      attributes = BibtexImport::Entry.new(data).article_attributes
      article = Article.new(attributes)
      article.user = user
      article
    end
  end

  def save
    new_articles.each(&:save)
  end

  def filename
    @file.try(:original_filename) || 'No file'
  end

  private

  def bibliography
    BibTeX::Bibliography.parse(bibtex_source)
  end

  class Entry
    def initialize(data)
      @data = data
    end

    def article_attributes
      {
        title: @data.title,
        source: "bibtex",
        identifiers: new_identifiers
      }
    end

    private

    def new_identifiers
      identifier_bodies.map { |body| Identifier.new(body: body) }
    end

    def identifier_bodies
      identifier_pairs.to_a.map do |key, value|
        "#{key.upcase}:#{value}" if value.present?
      end.compact
    end

    def identifier_pairs
      {
        url: @data['url'],
        issn: @data['issn'],
        isbn: @data['isbn'],
        pmid: @data['pmid'] || parse_zotero_pmid,
        pmcid: @data['pmcid'] || parse_zotero_pmcid
      }
    end

    def parse_zotero_pmid
      $1 if note.match(/{PMID:} (\d+)/)
    end

    def parse_zotero_pmcid
      $1 if note.match(/{PMCID:} {(PMC\d+)}/)
    end

    def note
      @data['note'] || ''
    end
  end
end
