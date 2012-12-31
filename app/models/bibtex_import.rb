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
    valid_bibliography_entries.map do |entry|
      Article.new(entry.article_attributes).tap do |article|
        article.user = user
      end
    end
  end

  def save
    new_articles.each(&:save)
  end

  def filename
    @file.try(:original_filename) || 'No file'
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
        title: strip_latex_html_tags(@data['title'].to_s),
        author: strip_latex_html_tags(@data['author'].to_s),
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
        url: @data['url'],
        issn: @data['issn'],
        isbn: @data['isbn'],
        pmid: parse_pmid,
        pmcid: parse_pmcid
      }
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
