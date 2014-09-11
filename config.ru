require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require './wikidocument'
require './app'
#requires for app.rb
# require 'securerandom'
# require 'sinatra/base'
# require 'redcarpet'
# require 'httparty'
# require 'rack/ssl'

# require 'redis'
# require 'json'
# # require 'pry' if ENV['RACK_ENV'] == 'development'
# require 'uri'

run App
