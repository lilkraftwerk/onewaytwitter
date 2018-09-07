require 'telegram_bot'
require 'twitter'
require 'byebug'
require 'httparty'
require 'open-uri'

require_relative 'keys'
require_relative 'twitter'
require_relative 'utils'

BASE_URL = "https://api.telegram.org/bot#{TELEGRAM_TOKEN}"

class HttpWrapper
    def self.call(url, params = {})
        return HTTParty.get(url, params).parsed_response['result']
    end
end

class TelegramWrapper
    attr_reader :response, :last_id, :groups

    def initialize(token)
        @token = token
    end

    def get_updates
        url = "#{BASE_URL}/getUpdates"
        @response = HttpWrapper.call(url, { query: { timeout: 1 }})
        puts "messages length: #{@response.length}"
    end

    def last_update_id
        @response.map {|message| message["update_id"] }.max
    end

    def clear_updates
        return if last_update_id.nil?
        url = "#{BASE_URL}/getUpdates"
        new_messages = HttpWrapper.call(url, { query: { offset: last_update_id + 1, timeout: 1}})
        puts "clearing messages... new messages length: #{new_messages.length}"
    end
end

class Message
    attr_reader :text, :photo, :media_group_id, :caption, :user_name, :id, :reply_id, :photo, :local_filename

    def initialize(message)
        content = message["message"]
        @id = message["update_id"]
        @user_name = content["from"]["username"]
        @text = content["text"]
        @caption = content["caption"]
        @reply_id = content["message_id"]
        @chat_id = content["chat"]["id"]
        @photo = content["photo"].last unless content["photo"].nil?
        @media_group_id = content["media_group_id"] || "none"

        download_photo
    end

    def has_photos?
        !@photo.nil? 
    end
    
    def download_photo
        return unless has_photos?
        url = "#{BASE_URL}/getFile?file_id=#{@photo['file_id']}"
        web_path = HttpWrapper.call(url)["file_path"]
        filename = web_path.split('/').last
        @local_filename = "tmp/#{filename}"
        if File.exist?(@local_filename)
            puts "file #{@local_filename} exists, not downloading..."
        else 
            url = "https://api.telegram.org/file/bot#{TELEGRAM_TOKEN}/#{web_path}"
            open(@local_filename, 'wb') do |file|
                file << open(url).read
            end
        end
    end
end

telegram = TelegramWrapper.new(TELEGRAM_TOKEN)
telegram.get_updates
messages = telegram.response.map {|message_object| Message.new(message_object)}
sorted = MessageWizard.sort_photos_and_text(messages)
assigned = MessageWizard.assign_to_classes(sorted)

tweety = TwitterClient.new
tweety.post_em_all(assigned)

telegram.clear_updates
