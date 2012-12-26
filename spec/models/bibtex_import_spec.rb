require 'spec_helper'

describe BibtexImport do
  it 'handles a variety of entry formats' do
    sample_file = File.open(Rails.root.join('spec/fixtures/bibdesk-sample.bib'))
    import = BibtexImport.new(file: sample_file)
    import.new_articles.count.should == 3
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
