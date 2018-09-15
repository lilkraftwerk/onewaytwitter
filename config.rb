require_relative "keys" if File.exist?("keys.rb")

require 'twitter'
require 'byebug'
require 'httparty'
require 'open-uri'

$TWITTER_KEY ||= ENV['TWITTER_KEY']
$TWITTER_SECRET ||= ENV['TWITTER_SECRET']
$ACCESS_TOKEN ||= ENV['ACCESS_TOKEN']
$ACCESS_SECRET ||= ENV['ACCESS_SECRET']
$TELEGRAM_TOKEN ||= ENV['TELEGRAM_TOKEN']
$TELEGRAM_USERNAME ||= ENV['TELEGRAM_USERNAME']

Dir["./code/*.rb"].each { |file| require file }

$ROOT = File.expand_path File.dirname(__FILE__)
$BASE_URL = "https://api.telegram.org/bot#{$TELEGRAM_TOKEN}"
