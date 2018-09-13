require_relative 'config'

task :get do
    telegram = TelegramWrapper.new($TELEGRAM_TOKEN)
    telegram.get_updates
    messages = telegram.response.map {|message_object| Message.new(message_object)}
    sorted = MessageWizard.sort_photos_and_text(messages)
    assigned = MessageWizard.assign_to_classes(sorted)
    byebug
end

task :post do
    telegram = TelegramWrapper.new($TELEGRAM_TOKEN)
    telegram.get_updates
    messages = telegram.response.map {|message_object| Message.new(message_object)}
    sorted = MessageWizard.sort_photos_and_text(messages)
    assigned = MessageWizard.assign_to_classes(sorted)
    tweety = TwitterClient.new
    tweety.post_em_all(assigned)
    telegram.clear_updates
end
