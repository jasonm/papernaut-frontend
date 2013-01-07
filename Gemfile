source 'https://rubygems.org'

gem 'rails', '3.2.10'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'omniauth'
gem 'omniauth-oauth'
gem 'omniauth-zotero'
gem 'omniauth-mendeley', git: 'git://github.com/jasonm/omniauth-mendeley.git'
gem 'faraday'
gem 'ratom', require: 'atom'
gem 'devise'
gem 'addressable'
gem 'sidekiq'

gem 'rails-footnotes', '>= 3.7.5.rc4', :group => :development

gem 'bootstrap-sass'

gem 'bibtex-ruby'
gem 'simple_form'

gem 'high_voltage'
gem 'rack-canonical-host'
gem 'newrelic_rpm'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :development do
  gem 'pry'
  gem 'pry-rails'
  gem 'guard-livereload'
  gem 'foreman'
end

group :development, :darwin do
  gem 'rb-fsevent', '~> 0.9.1'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'capybara'
  gem 'database_cleaner'
end

group :test, :development do
  gem 'rspec-rails', '~> 2.0'
  gem 'pry-debugger'
  gem 'factory_girl_rails'
  gem 'dotenv'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

gem 'thin'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
