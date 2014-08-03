require 'nokogiri'
require 'open-uri'
require 'yaml'


pwd = File.dirname(__FILE__)
output_path = File.join(pwd, 'episodes')
episode_list = File.join(output_path, 'episode_list.yml')

feed_url = 'http://rubyrogues.com/feed/'
# feed_url = 'http://rubyrogues.com/podcast.rss'
xml = open(feed_url).read

doc = Nokogiri::XML(xml)

items = doc.search('item')

episodes = YAML::load(File.read(episode_list))

highest_feed_number = episodes.max {|episode| episode[:feed_number].to_i }[:feed_number]

items.reverse.each  do |item|
  title = item.at('title').text
  next if episodes.find {|episode| episode[:title] == title }
  enclosure = item.at('enclosure')
  enclosure = enclosure && enclosure.attribute('url').value.split('/')[-1]
  feed_number = highest_feed_number + 1
  highest_feed_number += 1
  episodes << {
    feed_number: feed_number,
    title: title,
    enclosure: enclosure
  }
  File.open("#{output_path}/#{feed_number}.xml", 'w') do |file|
    file.write(item.to_xml)
  end
end
File.open(episode_list, 'w') do |file|
  file.write(episodes.to_yaml)
end
