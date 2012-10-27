# Be sure to restart your server when you modify this file.

Niaowo::Application.config.session_store :cookie_store, key: '_niaowo_session'

Niaowo::Application.config.session_store :redis_store, servers: ['redis://127.0.0.1:6379/1/sessions', ]
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Niaowo::Application.config.session_store :active_record_store
