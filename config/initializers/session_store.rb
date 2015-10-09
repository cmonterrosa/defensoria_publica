# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_defensoria_publica_session',
  :secret      => '3c6ac8b25881155f687e1d7c2c14bc23a5715ae092b065fcbc4c3c58b91c4fb2ef664256cc02de0c1ba99365a958221a1ada07f661768983ab28fa2715f7cf3d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
