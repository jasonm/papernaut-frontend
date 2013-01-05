PapernautFrontend::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root to: 'welcome#index'

  devise_scope :user do
    delete "sign_out", :to => "devise/sessions#destroy"
  end

  resources :imports, only: %w(new)
  resources :bibtex_imports, only: %w(new create)
  resources :discussions, only: %w(index)
end
