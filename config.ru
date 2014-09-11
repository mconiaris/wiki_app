require 'rubygems'
require 'bundler'


# requires for app.rb
require 'sinatra/base'
require 'securerandom'
require 'redcarpet'
require 'httparty'
# require 'rack/ssl'

require 'redis'
require 'json'
require 'pry' if ENV['RACK_ENV'] == 'development'
require 'uri'
# Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require './wikidocument'
require './app'
run App
