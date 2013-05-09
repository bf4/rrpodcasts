require 'yaml'

pwd = File.dirname(__FILE__)
feed = File.join(pwd, 'public/index.xml')
output_path = File.join(pwd, 'episodes')
feed_header = File.read File.join(pwd, 'feed_header.xml')
feed_footer = File.read File.join(pwd, 'feed_footer.xml')
episode_list = File.join(output_path, 'episode_list.yml')

episodes = YAML::load(File.read(episode_list)).reverse

File.write(feed, [
  feed_header,
  episodes.map {|episode| File.read(File.join(output_path, "#{episode[:feed_number]}.xml"))},
  feed_footer].flatten.join("\n")
  )
