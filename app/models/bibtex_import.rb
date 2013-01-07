require 'bibtex'

class BibtexImport
  MAX_AUTHOR_LENGTH = 1024
  MAX_TITLE_LENGTH = 1024

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :file, :bibtex_source, :user
  attr_reader :filename

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  # TODO test case demonstrating need for read-binary and UTF-8
  def file=(new_file)
    @file = File.open(new_file.path, 'rb')
    @filename = new_file.original_filename || 'No file' rescue 'No file'
    @bibtex_source = @file.read.force_encoding("UTF-8")
  end

  def new_articles
    valid_bibliography_entries.map do |entry|
      Article.new(entry.article_attributes).tap do |article|
        article.user = user
      end
    end
  end

  def save
    new_articles.each(&:save)
  end

  private

  def valid_bibliography_entries
    bibliography.data.map do |data|
      next if ! data.is_a? BibTeX::Entry

      entry = BibtexImport::Entry.new(data)
      next if !entry.valid?

      entry
    end.compact
  end

  def bibliography
    BibTeX::Bibliography.parse(bibtex_source).convert(:latex)
  end

  class Entry
    def initialize(data, doi_class = Doi)
      @data = data
      @doi_class = doi_class
    end

    def article_attributes
      {
        title: strip_latex_html_tags(@data['title'].to_s).truncate(MAX_TITLE_LENGTH),
        author: strip_latex_html_tags(@data['author'].to_s).truncate(MAX_AUTHOR_LENGTH),
        source: "bibtex",
        identifiers: identifiers
      }
    end

    def valid?
      article_attributes[:title].present? && article_attributes[:identifiers].any?
    end

    def identifiers
      identifier_bodies.map { |body| Identifier.new(body: body) }
    end

    private

    def identifier_bodies
      identifier_pairs.map do |key, value|
        "#{key.upcase}:#{value}" if value.present?
      end.compact
    end

    def identifier_pairs
      {
        doi: parse_and_validate_doi,
        url: parse_url,
        issn: @data['issn'],
        isbn: @data['isbn'],
        pmid: parse_pmid,
        pmcid: parse_pmcid
      }
    end

    def parse_url
      if @data['url']
        uri = URI.parse(@data['url'])
        uri.to_s if uri.path.present?
      end
    rescue URI::InvalidURIError
      nil
    end

    def parse_and_validate_doi
      doi = @data['doi'] || doi_by_url_from(note)

      if doi && @doi_class.new(doi).exists?
        doi
      end
    end

    def doi_by_url_from(string)
      uris = URI.extract(string, %w(http https)).map { |uri| URI.parse(uri) }

      if doi_uri = uris.detect { |uri| uri.host == 'dx.doi.org' }
        doi_uri.path.sub('/', '')
      end
    end

    def parse_pmid
      if @data['pmid']
        @data['pmid'].to_s
      elsif (note + annote) =~ /PMID: (\d+)/
        $1
      end
    end

    def parse_pmcid
      if @data['pmcid']
        @data['pmcid'].to_s
      elsif (note + annote) =~ /PMCID: (PMC\d+)/
        $1
      end
    end

    def note
      @data['note'].to_s
    end

    def annote
      @data['annote'].to_s
    end

    def strip_latex_html_tags(string)
      string.gsub(/\\textless\/?\w+\\textgreater/, '')
    end
  end
end
