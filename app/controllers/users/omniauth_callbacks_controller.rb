class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def zotero
    # @user = User.find_or_create_from_auth_hash(auth_hash)
    # self.current_user = @user
    # redirect_to '/'

    # raise "got to OmniauthCallbacksController"

    data = {
      'zotero_key'  => auth_hash.credentials.token,
      'zotero_name' => auth_hash.info.name,
      'zotero_uid'  => auth_hash.uid
    }

    zotero_user = ZoteroClient::User.new(data['zotero_uid'], data['zotero_key'])

    render text: zotero_user.items.inspect
  end

  # def facebook
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

  #   if @user.persisted?
  #     flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
  #     sign_in_and_redirect @user, :event => :authentication
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
