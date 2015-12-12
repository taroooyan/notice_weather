#require 'rubygems'
require 'serialport'
require 'net/http'
require 'json'
require 'open-uri'
require 'date'

def get_weather
  # 気象庁（http://www.jma.go.jp/jp/week/313.html）
  uri = URI.parse('http://www.drk7.jp/weather/json/07.js')
  jsonp = Net::HTTP.get(uri)
  jsonp = jsonp.split("drk7jpweather.callback(").join
  json = jsonp.split(");").join
  result = JSON.parse(json)
  day = Date.today

  for i in 0..result['pref']['area']['会津']['info'].length-1 do
    # 日付
    puts day = day + 1
    # 気温
    puts "気温"
    result['pref']['area']['会津']['info'][i]['temperature']['range'].each do |data|
      puts "\t#{data['centigrade']} #{data['content']}"
    end
    # 降水確率
    puts "降水確率"
    result['pref']['area']['会津']['info'][i]['rainfallchance']['period'].each do |data|
      puts "\t#{data['hour']} #{data['content']}%"
    end
    # 天気
    puts "天気"
    puts "\t" + result['pref']['area']['会津']['info'][i]['weather']
    # 音声に変換
    cmd = %(curl "https://api.voicetext.jp/v1/tts" -d "speaker=hikari" -u #{ENV["API_TOKEN"]} -o \"#{day}.wav\" -d \"text=#{day}の天気は#{result['pref']['area']['会津']['info'][i]['weather']}\")
    %x[ #{cmd} ]
    puts "--------------"
  end
end

def main
  port = "/dev/tty.usbmodemfa131"
  sp = SerialPort.new(port, 9600, 8, 1, SerialPort::NONE)
  loop do
    puts sp.readline
    if sp.readline.to_i < 30
      puts 'notice'
      # OSXに入っているafplayを使用して音声を再生
      cmd = "afplay #{Date.today}.wav"
      %x[ #{cmd} ]
      while sp.readline.to_i < 30
      end
    end
    # 毎日2時になったら更新
    if DateTime.now.hour == DateTime.now.hour
      get_weather
    end
  end
  sp.close
end

main
