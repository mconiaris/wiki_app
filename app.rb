require 'sinatra/base'
require 'pry'

class App < Sinatra::Base

  ########################
  # Configuration
  ########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions

    # FIXME getting a nil value from the ENV value
    GOOGLE_CLIENT_ID = ENV['GOOGLE_WIKI_APP_ID']

  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end

  ########################
  # Routes
  ########################

# https://127.0.01:3000/
# https://127.0.01:3000/oauth2callback

  get('/') do
    # This endpoint is accessible over SSL, and
    # HTTP connections are refused.
    GOOGLE_ENDPOINT = "https://accounts.google.com/o/oauth2/auth"
    GOOGLE_REDIRECT_URI = "https://localhost:3000/oauth2callback"

    @url = "#{GOOGLE_ENDPOINT}?scope=email" +
      "&redirect_uri=#{GOOGLE_REDIRECT_URI}" +
      "&response_type=code" +
      "&client_id=#{GOOGLE_CLIENT_ID}" +
      "&approval_promt=force"
      # binding.pry
    render(:erb, :index)
  end

  get('/oauth2callback') do
    # binding.pry
  end

  # Google recommend that the server first
  # handle the request, then redirect to
  # another URL that doesn't include the
  # responsenparameters.
  # TODO redirect link.
end
