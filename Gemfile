# A sample Gemfile
source "https://rubygems.org"

ruby "2.1.2"

gem 'sinatra', '1.4.5'
gem 'redis',  '3.1.0'
gem 'redcarpet'
gem 'markdown'
gem 'httparty'
  # To create SSL connections as required
  # by Google's Oauth2 tool
gem 'rack-ssl'

# only used in development locally
group :development do
  gem 'pry'
  gem 'shotgun'
end

group :production do
  # gems specific just in the production environment
end

group :test do
  gem 'rspec'
  gem 'capybara'
end
