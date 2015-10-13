# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_scaffold_session',
  :secret      => '061d0fa13ca0a3b347e82f7a0d69fe23111c8ff7f5ff03609020fb8e004eabb459e2ecf0870d6390c8e091b32d7e45721e768919df6f2229dce760cb005b380a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
