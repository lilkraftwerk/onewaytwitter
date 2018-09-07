class MessageWizard    
    def self.sort_photos_and_text(messages)
        text_tweets = []
        image_tweets = Hash.new { |hash, key| hash[key] = [] }
        messages.each do |message|
            media_id = message.media_group_id
            if media_id == "none"
                text_tweets << message
            else 
                image_tweets[media_id] << message
            end
        end

        { 
            text: text_tweets,
            image: image_tweets.values
        }
    end

    def self.assign_to_classes(sorted_messages)
        text_tweets = sorted_messages[:text].map do |message|
            TextTweet.new(message)
        end

        image_tweets = sorted_messages[:image].map do |msg_array|
            ImageTweet.new(msg_array)
        end

        { 
            text: text_tweets,
            image: image_tweets
        }
    end
end

class ImageTweet
    attr_reader :caption, :filenames

    def initialize(msg_array)
        @msg_array = msg_array 
        make_caption
        make_photo_list
    end

    def make_caption
        @caption = @msg_array.map {|msg| msg.caption}.compact.join(' / ')
    end

    def make_photo_list
        @filenames = @msg_array.map{ |x| x.local_filename }.first(4)
    end
end

class TextTweet
    def initialize(message)
        @message = message
    end

    def text
        @message.text
    end
end
