class TwitterClient
	def initialize
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key = TWITTER_KEY
			config.consumer_secret = TWITTER_SECRET
			config.access_token = ACCESS_TOKEN
			config.access_token_secret = ACCESS_SECRET
		end
	end
	
    def update(text)
        @client.update(text)
    end

    def post_with_many_images(text, files)
        @client.update_with_media(text, files, options = {})
    end

	def post_em_all(categorized_tweets)
		text = categorized_tweets[:text]
		img = categorized_tweets[:image]

		puts "#{text.length} text tweets, #{img.length} img tweets to post"

		text.each do |text_tweet|
			puts "posting text #{text_tweet.text}"
			@client.update(text_tweet.text)
		end

		img.each do |img_tweet|
			puts "posting text #{img_tweet.caption}"
			# https://www.rubydoc.info/gems/twitter/Twitter%2FREST%2FTweets:update_with_media
			@client.update_with_media(img_tweet.caption, img_tweet.filenames)
		end
	end
end



