require 'spec_helper'

describe "signing in via Zotero OAuth" do
  it "signs the user in", js: true do
    VCR.use_cassette('zotero-oauth-jayunit', match_requests_on: [:host, :path]) do
      zotero_username = ENV['ZOTERO_USERNAME'] || 'jason.p.morrison@gmail.com'
      zotero_password = ENV['ZOTERO_PASSWORD'] || raise("Provide ENV['ZOTERO_PASSWORD'] for automated tests")

      visit '/'
      click_link 'Connect with Zotero'

      page.should have_content('Login to Zotero')
      fill_in 'username', with: zotero_username
      fill_in 'password', with: zotero_password
      click_button 'Login to Zotero'

      page.should have_content('An application would like to connect to your account')
      click_button 'Accept Defaults'

      page.should have_content('Matches for jayunit from Zotero')
    end
  end
end
