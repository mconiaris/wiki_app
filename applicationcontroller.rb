require './helpers/application_helper.rb'

class ApplicationController < Sinatra::Base

  ########################
  # Configuration
  ########################

  helpers ApplicationHelper

  configure do
    enable :logging
    enable :method_override
    enable :sessions
    # TODO: Research set :session_secret further
    # set the secret yourself, so all your
    # application instances share it:
    set :session_secret, 'super secret'

    GOOGLE_CLIENT_ID = ENV['GOOGLE_WIKI_APP_ID']
    GOOGLE_CLIENT_SECRET = ENV['GOOGLE_WIKI_APP_CLIENT_SECRET']
    # This endpoint is accessible over SSL, and
    # HTTP connections are refused.
    GOOGLE_ENDPOINT = "https://accounts.google.com/o/oauth2"
    # TODO: Use high5 to get https working instead.
    # Heroku offers https on all their deployed sites.
    # GOOGLE_REDIRECT_URI = "http://localhost:3000/oauth2callback"
    GOOGLE_REDIRECT_URI = "http://shrouded-anchorage-2122.herokuapp.com/oauth2callback"
    uri = URI.parse(ENV["REDISTOGO_URL"])
    # :db sets which of the 15 Redis databases
    # that you will use.
    $redis = Redis.new({:host => uri.host,
                    :port => uri.port,
                    :password => uri.password,
                    :db => 12})
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end
end
