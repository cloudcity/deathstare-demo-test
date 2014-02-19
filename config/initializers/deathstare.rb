Deathstare.configure do
  # This is the testing app's ID returned by the /apps API
  # We use it to verify that the user has permissions on this particular app.
  config.heroku_app_id = ENV['HEROKU_APP_ID']
  config.heroku_oauth_id = ENV['HEROKU_OAUTH_ID']
  config.heroku_oauth_secret = ENV['HEROKU_OAUTH_SECRET']
  config.librato_email = ENV['LIBRATO_EMAIL']
  config.librato_api_token = ENV['LIBRATO_API_TOKEN']
  config.target_urls << 'http://widget.example.com'
  config.upstream_session_type = WidgetDevice
end

