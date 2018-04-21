require 'telegram/bot'
require 'json'
require 'yaml'

config = YAML::load(open('config.yml')) 

Telegram::Bot::Client.run([config"token"]) do |bot|
	bot.listen do |message|
	case message.text
		when '/start'
			kb = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: ["проверить"])
			bot.api.send_message(chat_id: message.chat.id, text: "бот запущен", reply_markup: kb)
		when 'проверить'
			# bot.api.send_message(chat_id: message.chat.id, text: `ifconfig`.scan(/(?<=(\())(\d*.\d \w{1,3})/)[1][1].to_s)
			traffic_viewer = JSON.parse `sh ./traffic_viewer.sh --json`
			text = """
**Статистика использования трафика**

__входящий__: `#{traffic_viewer["input"]}`
__исходящий__: `#{traffic_viewer["output"]}`
__всего__: `#{traffic_viewer["total"]}`
			"""
			bot.api.send_message(chat_id: message.chat.id, text: text)
		end
	end
end
