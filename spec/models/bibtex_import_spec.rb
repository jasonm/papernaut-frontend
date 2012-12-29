require 'spec_helper'

describe BibtexImport do
  before do
    Doi.any_instance.stub(:exists?).and_return(true)
  end

  it 'handles a variety of entry formats' do
    sample_file = File.open(Rails.root.join('spec/fixtures/bibdesk-sample.bib'))
    import = BibtexImport.new(file: sample_file)
    import.new_articles.count.should == 4

    import.new_articles.map(&:title).should == [
      "Studies on the Life Cycles of Akinete Forming Cyanobacteria",
      "Bioactive glass or ceramic substrates having bound cell adhesion molecules - US Patent 6413538",
      "Synthetic biology: new engineering rules for an emerging discipline",
      "Evaluating the biological potential in samples returned from planetary satellites and small solar system bodies : framework for decision making"
    ]
  end

  it 'handles errors' do
    error_file = File.open(Rails.root.join('spec/fixtures/bibdesk-error.bib'))
    import = BibtexImport.new(file: error_file)
    import.new_articles.count.should == 0
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
end

describe BibtexImport::Entry, "with DOI verification" do
  it 'imports DOI field' do
    fake_doi = double(exists?: true)
    fake_doi.should_receive(:exists?)

    entry = BibtexImport::Entry.new({ 'doi' => '10.1128/MMBR.00015-07' }, double(new: fake_doi))
    entry.identifiers.map(&:body).should == ["DOI:10.1128/MMBR.00015-07"]
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


