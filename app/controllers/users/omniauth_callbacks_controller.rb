class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def zotero
    @user = User.find_or_create_for_zotero_oauth(auth_data)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Zotero"
      sign_in_and_redirect @user, :event => :authentication
    else
      raise "Could not persist user"
      # session["devise.zotero_data"] = request.env["omniauth.auth"]
      # redirect_to root_url
    end
  end

  protected

  def auth_data
    {
      'zotero_key'      => request.env['omniauth.auth'].credentials.token,
      'zotero_username' => request.env['omniauth.auth'].info.name,
      'zotero_uid'      => request.env['omniauth.auth'].uid
    }
  end
end
