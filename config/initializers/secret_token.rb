# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# XXX this fails during asset compilation because the config isn't set
# if Rails.env.production? && ENV['SECRET_KEY'].blank?
#   raise 'SecretToken Missing! Please set SECRET_KEY (generate one with `rake secret`)'
# end

WidgetTest::Application.config.secret_key_base = ENV['SECRET_KEY'] || '849f2ce08fa195c8ed18b8cfa11ee2964080429ab66a421d41c5c184222c0ac8fc538a8518975aa61d53ccf777abdcff5b920611841550ab519f6bc12a331dfc'
