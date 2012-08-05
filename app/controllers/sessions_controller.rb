class SessionsController < ApplicationController
  def create
    # @user = User.find_or_create_from_auth_hash(auth_hash)
    # self.current_user = @user
    # redirect_to '/'

    data = {
      'zotero_key'  => auth_hash.credentials.token,
      'zotero_name' => auth_hash.info.name,
      'zotero_uid'  => auth_hash.uid
    }.to_json

    render text: data
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
