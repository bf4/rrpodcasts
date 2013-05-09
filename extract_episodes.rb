require 'nokogiri'
require 'yaml'

pwd = File.dirname(__FILE__)
filename = File.join(pwd, 'public/index.xml')
output_path = File.join(pwd, 'episodes')
episode_list = File.join(output_path, 'episode_list.yml')
xml = File.read(filename)

doc = Nokogiri::XML(xml)

items = doc.search('item').reverse

episodes = []

items.each_with_index  do |item, index|
  feed_number = index + 1
  title = item.at('title').text
  enclosure = item.at('enclosure')
  enclosure = enclosure && enclosure.attribute('url').value.split('/')[-1]
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
