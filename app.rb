require 'telegram/bot'
require 'json'
require 'yaml'

CONFIG = YAML::load(open('config.yml')) 

def convert_traffic_output(arg)
	if ( arg / 1048576) >= 1 
		"#{"%.2f" % (arg / 1048576.0)} GiB"
	elsif ( arg / 1024) >= 1 
		"#{"%.2f" % (arg / 1024.0)} MiB"
	else
		"#{"%.2f" % (arg)} KiB"
	end
end

def format_table(stat)
"""in: `#{convert_traffic_output stat["tx"]}` | out: `#{convert_traffic_output stat["rx"]}`
total: `#{convert_traffic_output stat["tx"] + stat["rx"]}`"""
end

def get_stats
	vnstat = JSON.parse(`vnstat --json`)

	total = vnstat["interfaces"][CONFIG["adapter"]]["traffic"]["total"]
	this_month = vnstat["interfaces"][CONFIG["adapter"]]["traffic"]["months"][0]
	today = vnstat["interfaces"][CONFIG["adapter"]]["traffic"]["days"][0]
"""__total__
#{format_table total}

__this month:__ #{this_month["date"]["year"]}-#{this_month["date"]["month"]}
#{format_table this_month}

__today:__ #{today["date"]["year"]}-#{today["date"]["month"]}-#{today["date"]["day"]}
#{format_table today}"""	
end

Telegram::Bot::Client.run(CONFIG["token"]) do |bot|
	bot.listen do |message|
	case message.text
		when '/start'
			kb = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: ["check"])
			bot.api.send_message(chat_id: message.chat.id, text: "Hi human!", reply_markup: kb)
		when 'check'
			bot.api.send_message(chat_id: message.chat.id, text: get_stats, parse_mode: "Markdown")
		end
	end
end
