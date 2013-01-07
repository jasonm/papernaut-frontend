require 'spec_helper'

describe Doi do
  it 'eventually gets re-enabled when it can be backgrounded or otherwise sped up'

  # it "tells if a DOI exists" do
  #   VCR.use_cassette('good-dois') do
  #     good = %w(10.1146/annurev.biochem.75.103004.142723
  #               10.1128/MMBR.00015-07
  #               10.3732/ajb.0800258)

  #     good.each do |doi|
  #       Doi.new(doi).exists?.should be_true
  #     end
  #   end
  # end

  # it "tells if a DOI does not exist" do
  #   VCR.use_cassette('bad-dois') do
  #     bad  = %w(14577883
  #               10196780
  #               841R277626120882)

  #     bad.each do |doi|
  #       Doi.new(doi).exists?.should be_false
  #     end
  #   end
  # end
end
