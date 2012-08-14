require 'spec_helper'

describe "signing in via Zotero OAuth" do
  it "signs the user in", js: true do
    VCR.use_cassette('zotero-oauth-jayunit') do
      visit '/'
      click_link 'Connect with Zotero'

      page.should have_content('Login to Zotero')
      fill_in 'username', with: 'jason.p.morrison@gmail.com'
      fill_in 'password', with: 'password'
      click_button 'Login to Zotero'

      page.should have_content('An application would like to connect to your account')
      click_button 'Accept Defaults'

      page.should have_content('Successfully authenticated')
      page.should have_content('Zotero Library for jayunit')
    end
  end
end
