require_relative "keys" unless ENV["HEROK_TRUE"]

require 'twitter'
require 'byebug'
require 'httparty'
require 'open-uri'

Dir["./code/*.rb"].each {|file| require file }

$ROOT = File.expand_path File.dirname(__FILE__)
$BASE_URL = "https://api.telegram.org/bot#{TELEGRAM_TOKEN}"