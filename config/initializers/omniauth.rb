Rails.application.config.middleware.use OmniAuth::Builder do
  zotero_key = '40b254ff45835ab31cdf'
  zotero_secret = 'e32947c055c489eda7b4'
  provider :zotero, zotero_key, zotero_secret
end
