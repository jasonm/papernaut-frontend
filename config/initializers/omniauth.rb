require 'omniauth-oauth'

module OmniAuth
  module Strategies
    class Zotero < OmniAuth::Strategies::OAuth
      option :name, "zotero"

      option :client_options, {
        :site => 'https://www.zotero.org',
        :request_token_path => '/oauth/request',
        :access_token_path => '/oauth/access',
        :authorize_path => '/oauth/authorize',
        :scheme => :query_string
      }

      uid do
        raw_info['userID'].to_i
      end

      info do
        {
          'name' => raw_info['username']
        }
      end

      credentials do
        {
          'token' => raw_info['oauth_token'],
          'secret' => raw_info['oauth_token_secret']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      private

      def raw_info
        access_token.params
      end

      def callback_phase
        session['oauth'][name.to_s]['callback_confirmed'] = true
        super
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
