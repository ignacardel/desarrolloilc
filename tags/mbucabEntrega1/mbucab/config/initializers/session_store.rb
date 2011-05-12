# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mbucab_session',
  :secret      => '6e183e76ec8a985da7d2daf45e39c80f7142c561cee03b42772dc538b55b6d8f1017e02f4b229270d7246a2aff5f63526aed0f36e06eda77cb3825ed94b4e7a5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
