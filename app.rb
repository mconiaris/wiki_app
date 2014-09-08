require './wikidocument'
require 'securerandom'
require 'sinatra/base'
require 'redcarpet'
require 'httparty'
require 'rack/ssl'
require 'redis'
require 'json'
require 'pry'
require 'uri'

# TODO: newer way for Google Oauth:
# https://developers.google.com/accounts/docs/OAuth2Login#createxsrftoken

# TODO Look into use command in Ruby
class App < Sinatra::Base
  extend Redcarpet
  # use Rack::SSL

  ########################
  # Configuration
  ########################

  configure do
    enable :logging
    enable :method_override
    enable :sessions
    # Research set :session_secret further
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
    GOOGLE_REDIRECT_URI = "http://localhost:3000/oauth2callback"
    uri = URI.parse(ENV["REDISTOGO_URL"])
    $redis = Redis.new({:host => uri.host,
                    :port => uri.port,
                    :password => uri.password})
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end

  ########################
  # Methods
  ########################

  def get_articles
    raw_data = $redis.get("article")
    display = JSON.parse(raw_data)
  end

  #TODO: Render both params. Format on Wiki Page
  def render_to_html(title, text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions={})
    rendered_title = markdown.render(title)
    rendered_text = markdown.render(text)
  end

  ########################
  # Routes
  ########################


  get('/') do
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
    # TODO right now the URL has approval_prompt
    # value of force, which shows the consent
    # screen everytime I attempt to login. This
    # should be deleted once testing is done.
    # The default is auto which only shows the
    # screen when approval is needed.
    @url = "#{GOOGLE_ENDPOINT}/auth?scope=email" +
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
    if session[:state] == params[:state]
      # send a POST
      # TODO: review HTTParty syntax on posts

      response = HTTParty.post("#{GOOGLE_ENDPOINT}/token",
        :body => {
          grant_type: 'authorization_code',
          code: code,
          client_id: GOOGLE_CLIENT_ID,
          client_secret: GOOGLE_CLIENT_SECRET,
          redirect_uri: GOOGLE_REDIRECT_URI,
          # response_type: code
        },
        :headers => {
          'Accept' => 'application/json',
          # Note to self, Google does not want application/json here
          "Content-Type" => "application/x-www-form-urlencoded",
          # "grant_type" => "authorization_code"

        })
        # binding.pry
      session[:access_token] = response["access_token"]
      end
    # Redirect to avoid rendering of auth code
    # issue?
    redirect to("/")
  end

  get '/documents' do
    render :erb, :documents
  end

  post('/documents') do
    doc = WikiDocument.new(
      params[:article_title],
      params[:article_author],
      params[:article_text])

    # binding.pry
    $redis.set("article", doc.to_json)
    binding.pry
    redirect '/documents'
  end

  get('/documents/new') do
    # binding.pry
    render :erb, :document_new
  end


  get('/logout') do
    binding.pry
    session[:access_token] = nil
    redirect to("/")
  end

  # Google recommend that the server first
  # handle the request, then redirect to
  # another URL that doesn't include the
  # responsenparameters.
  # TODO redirect link.
end
