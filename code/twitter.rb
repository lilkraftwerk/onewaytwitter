class TwitterClient
	def initialize
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key = $TWITTER_KEY
			config.consumer_secret = $TWITTER_SECRET
			config.access_token = $ACCESS_TOKEN
			config.access_token_secret = $ACCESS_SECRET
		end
	end
	
    def update(text)
        @client.update(text)
    end

	def post_with_many_images(text, files)
		begin
			@client.update_with_media(text, files, options = {})
		rescue
			puts "failed to post img"
		end
    end

	def post_em_all(categorized_tweets)
		text = categorized_tweets[:text]
		img = categorized_tweets[:image]

		puts "#{text.length} text tweets, #{img.length} img tweets to post"

		text.each do |text_tweet|
			begin
				result = @client.update(text_tweet.text)
				TelegramWrapper.respond(text_tweet)
			rescue => error
				TelegramWrapper.respond(text_tweet, false)
				puts "failed to post text"
			end
		end

		img.each do |img_tweet|
			begin
				puts "posting text #{img_tweet.caption}"
				result = @client.update_with_media(img_tweet.caption, img_tweet.filenames)
				TelegramWrapper.respond(img_tweet) 
			rescue => error
				TelegramWrapper.respond(text_tweet, false)
				puts "failed to post img"
			end
			# https://www.rubydoc.info/gems/twitter/Twitter%2FREST%2FTweets:update_with_media
		end
	end
end



