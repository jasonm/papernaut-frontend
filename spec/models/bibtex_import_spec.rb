require 'spec_helper'

module BibtexAssertions
  def attributes_should_yield_identifiers(attributes, identifier_bodies)
    BibtexImport::Entry.new(attributes).identifiers.map(&:body).should == identifier_bodies
  end
end

RSpec.configure do |config|
  config.include BibtexAssertions
end

describe BibtexImport do
  before do
    Doi.any_instance.stub(:exists?).and_return(true)
  end

  it 'handles a variety of entry formats' do
    sample_file = File.open(Rails.root.join('spec/fixtures/bibdesk-sample.bib'))
    import = BibtexImport.new(file: sample_file)
    import.new_articles.count.should == 5

    import.new_articles.map(&:title).should == [
      "Studies on the Life Cycles of Akinete Forming Cyanobacteria",
      "Bioactive glass or ceramic substrates having bound cell adhesion molecules - US Patent 6413538",
      "Microbial Activity in Frozen Soils",
      "Synthetic biology: new engineering rules for an emerging discipline",
      "Evaluating the biological potential in samples returned from planetary satellites and small solar system bodies : framework for decision making"
    ]
  end

  it 'handles errors' do
    error_file = File.open(Rails.root.join('spec/fixtures/bibdesk-error.bib'))
    import = BibtexImport.new(file: error_file)
    import.new_articles.count.should == 0
  end

  it 'finds variously latex-tagged objects' do
    bib = <<-BIB
      @article{andrianantoandro_synthetic_2006,
        Title = {yadda},
        Note = {{PMID:} 16738572}}
    BIB

    article = BibtexImport.new(bibtex_source: bib).new_articles.first
    article.identifiers.map(&:body).should == ["PMID:16738572"]
  end

  it 'strips latex-encoded html tags' do
    bib = <<-BIB
      @article{andrianantoandro_synthetic_2006,
        PMID = {16738572},
        Author = {\\textlesssup\\textgreatersuper person\\textless/sup\\textgreater},
        Title = {\\textlessi\\textgreater"Deinococcus radiodurans"\\textless/i\\textgreater - a model organism for life under Martian conditions}}
    BIB

    article = BibtexImport.new(bibtex_source: bib).new_articles.first
    article.title.should == '"Deinococcus radiodurans" - a model organism for life under Martian conditions'
    article.author.should == 'super person'
  end
end

describe BibtexImport::Entry do
  it "is valid when a title and identifiers are present" do
    valid_entry = BibtexImport::Entry.new({ 'title' => "title", 'url' => "url-identifier" })
    valid_entry.valid?.should be_true
  end

  it "is invalid when missing a title" do
    invalid_entry = BibtexImport::Entry.new({ 'url' => "url-identifier" })
    invalid_entry.valid?.should be_false
  end

  it "is invalid when missing identifiers" do
    invalid_entry = BibtexImport::Entry.new({ 'title' => "title" })
    invalid_entry.valid?.should be_false
  end

  it "imports the author" do
    BibtexImport::Entry.new({ 'author' => "Jane Smith" }).article_attributes[:author].should == 'Jane Smith'
  end
end

describe BibtexImport::Entry, "with DOI verification" do
  it 'imports DOI field' do
    fake_doi = double(exists?: true)
    fake_doi.should_receive(:exists?)

    entry = BibtexImport::Entry.new({ 'doi' => '10.1128/MMBR.00015-07' }, double(new: fake_doi))
    entry.identifiers.map(&:body).should == ["DOI:10.1128/MMBR.00015-07"]
  end

  it 'finds DOI URL in note field' do
    fake_doi = double(exists?: true)
    fake_doi.should_receive(:exists?)

    entry = BibtexImport::Entry.new({ 'note' => 'blah blah http://dx.doi.org/10.1007/978-3-540-69371-0_9 blah http://google.com blah' } , double(new: fake_doi))
    entry.identifiers.map(&:body).should == ["DOI:10.1007/978-3-540-69371-0_9"]
  end
end

describe BibtexImport::Entry, "when DOI verification fails" do
  it 'is invalid' do
    fake_doi = double(exists?: false)
    fake_doi.should_receive(:exists?)

    entry = BibtexImport::Entry.new({ 'doi' => 'some-bad-doi' }, double(new: fake_doi))
    entry.identifiers.should == []
  end
end

describe BibtexImport::Entry, "importing PMIDs" do
  it 'finds PMID in note, annote, pmid fields' do
    attributes_should_yield_identifiers({ 'note' => 'this is PMID: 1234' }, ['PMID:1234'])
    attributes_should_yield_identifiers({ 'annote' => 'this is PMID: 1234' }, ['PMID:1234'])
    attributes_should_yield_identifiers({ 'pmid' => '1234' }, ['PMID:1234'])
  end

  it 'finds PMCID in note, annote, pmcid fields' do
    attributes_should_yield_identifiers({ 'note' => 'this is PMCID: PMC5678' }, ['PMCID:PMC5678'])
    attributes_should_yield_identifiers({ 'annote' => 'this is PMCID: PMC5678' }, ['PMCID:PMC5678'])
    attributes_should_yield_identifiers({ 'pmcid' => 'PMC1234' }, ['PMCID:PMC1234'])
  end
end

