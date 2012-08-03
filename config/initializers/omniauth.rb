require 'omniauth-oauth'

module OmniAuth
  module Strategies
    class Zotero < OmniAuth::Strategies::OAuth
      # Give your strategy a name.
      option :name, "zotero"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      # option :client_options, {:site => "https://api.somesite.com"}

      option :client_options, {
        :site => 'https://www.zotero.org',
        :request_token_path => '/oauth/request',
        :access_token_path => '/oauth/access',
        :authorize_path => '/oauth/authorize',
        # :http_method => :get,
        :scheme => :query_string
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid do
        puts "finding UID.  Request params are:"
        p request.params
        puts "-"*80
        request.params['user_id']
      end

      # TODO: where to ask for specific permissions?

#           $access_token_info = get_access_token($state);
#     break;
# }
# // State 2 - Authorized. We have an access token stored already which we can use for requests on behalf of this user
# echo "Have access token for user.";
# //zotero will send the userID associated with the key along too
# $zoteroUserID = $access_token_info['userID'];
# //Now we can use the token secret the same way we already used a Zotero API key
# $zoteroApiKey = $access_token_info['oauth_token_secret'];

      info do
        {
          # :name => raw_info['name'],
          # :location => raw_info['city']
        }
      end

      extra do
        {
          # 'raw_info' => raw_info
        }
      end

      def raw_info
        {}
        # @raw_info ||= MultiJson.decode(access_token.get('/me.json')).body
      end
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  zotero_key = '40b254ff45835ab31cdf'
  zotero_secret = 'e32947c055c489eda7b4'
  provider :zotero, zotero_key, zotero_secret
  # Started GET "/auth/zotero/callback?oauth_token=5d241f60fc0c7f159078&oauth_verifier=06d1f411fc1a267ceb5b" for 127.0.0.1 at 2012-08-03 22:53:21 +0200
end
