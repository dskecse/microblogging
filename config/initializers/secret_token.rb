# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  unless File.exists?(token_file)
    # Generate a new token and store it in token_file.
    File.write(token_file, SecureRandom.hex(64))
  end
  File.read(token_file).chomp
end

Microblogging::Application.config.secret_key_base = secure_token
