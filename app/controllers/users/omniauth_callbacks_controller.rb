class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def zotero
    if current_user
      current_user.set_zotero_auth_fields(zotero_auth_data)
      current_user.save
      redirect_to new_import_url, notice: "Connected to Zotero"
    else
      @user = User.find_or_create_for_zotero_oauth(zotero_auth_data)

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Zotero"
        sign_in(@user)
        redirect_to new_import_url
      else
        raise "Could not persist user"
        # session["devise.zotero_data"] = request.env["omniauth.auth"]
        # redirect_to root_url
      end
    end
  end

  def mendeley
    if current_user
      current_user.set_mendeley_auth_fields(mendeley_auth_data)
      current_user.save
      redirect_to new_import_url, notice: "Connected to Mendeley"
    else
      @user = User.find_or_create_for_mendeley_oauth(mendeley_auth_data)

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Mendeley"
        sign_in(@user)
        redirect_to new_import_url
      else
        raise "Could not persist user"
        # session["devise.mendeley_data"] = request.env["omniauth.auth"]
        # redirect_to root_url
      end
    end
  end

  protected

  def zotero_auth_data
    {
      'zotero_key'      => request.env['omniauth.auth'].credentials.token,
      'zotero_username' => request.env['omniauth.auth'].info.name,
      'zotero_uid'      => request.env['omniauth.auth'].uid
    }
  end

  def mendeley_auth_data
    {
      'mendeley_uid'      => request.env['omniauth.auth'].uid,
      'mendeley_token'    => request.env['omniauth.auth'].credentials.token,
      'mendeley_secret'   => request.env['omniauth.auth'].credentials.secret,
      'mendeley_username' => request.env['omniauth.auth'].info.name
    }
  end
end
