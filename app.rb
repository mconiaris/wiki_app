require 'securerandom'
require 'sinatra/base'
require 'rack/ssl'
require 'pry'

# TODO Look into use command in Ruby
class App < Sinatra::Base
  # use Rack::SSL

  ########################
  # Configuration
  ########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions

    GOOGLE_CLIENT_ID = ENV['GOOGLE_WIKI_APP_ID']
    GOOGLE_CLIENT_SECRET = ENV['GOOGLE_WIKI_APP_CLIENT_SECRET']

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
    GOOGLE_REDIRECT_URI = "http://localhost:3000/oauth2callback"

    # https://developers.google.com/accounts/docs/OAuth2Login#createxsrftoken
    # The Google Authorization Server roundtrips
    # the state parameter, so your application
    # receives the same value it sent. To mitigate
    # against cross-site request forgery (CSRF),
    # it is strongly recommended to include an
    # anti-forgery token in the state, and confirm
    # it in the response.
    state = SecureRandom.urlsafe_base64
    # storing state in session because we need to
    # compare it in a later request
    session[:state] = state
    binding.pry
    # TODO right now the URL has approval_prompt
    # value of force, which shows the consent
    # screen everytime I attempt to login. This
    # should be deleted once testing is done.
    # The default is auto which only shows the
    # screen when approval is needed.
    @url = "#{GOOGLE_ENDPOINT}?scope=email" +
      "&redirect_uri=#{GOOGLE_REDIRECT_URI}" +
      "&response_type=code" +
      "&client_id=#{GOOGLE_CLIENT_ID}" +
      "&state=#{state}" +
      "&approval_promt=force"
      # binding.pry
    render(:erb, :index)
  end

  # TODO: Dig Deeper into this message from
  # the Google docs:
  # https://developers.google.com/accounts/docs/OAuth2WebServer
  # Important: if your response endpoint renders
  # an HTML page, any resources on that page will
  # be able to see the authorization code in the
  # URL. Scripts can read the URL directly, and
  # all resources may be sent the URL in the
  # Referer HTTP header. Carefully consider if
  # you want to send authorization credentials
  # to all resources on that page (especially
  # third-party scripts such as social plugins
  # and analytics). To avoid this issue, we
  # recommend that the server first handle the
  # request, then redirect to another URL that
  # doesn't include the response parameters.
  get('/oauth2callback') do
    code = params[:code]
    # compare the states to ensure the information is from who we think it is
        binding.pry
    if session[:state] == params[:state]
      # send a POST
      # TODO: review HTTParty syntax on posts
      response = HTTParty.post("#{GOOGLE_ENDPOINT}",
        :body => {
          code: code,
          client_id: GOOGLE_CLIENT_ID,
          client_secret: GOOGLE_CLIENT_SECRET,
          redirect_uri: GOOGLE_REDIRECT_URI,
          grant_type: authorization_code
        },
        :headers => {
          "Accept" => "application/json"
        })
      end
    # Redirect to avoid rendering of auth code
    # issue?
    redirect to("/")
  end

  # Google recommend that the server first
  # handle the request, then redirect to
  # another URL that doesn't include the
  # responsenparameters.
  # TODO redirect link.
end
