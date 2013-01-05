# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
PapernautFrontend::Application.config.secret_token = if Rails.env.production?
  ENV['SECRET_TOKEN'] || raise("Set ENV['SECRET_TOKEN'] for production")
else
  '02ee2ba5e845fd8014233dad346ed121213553c79add864375b59c4122c8c820402b42602c67a147716464e1086a8d20076f242c636ed7518c50899d640deec7'
end
