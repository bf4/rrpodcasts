require 'nokogiri'
require 'open-uri'
# https://github.com/berkshelf/berkshelf-api/blob/c0c764cfbf44b04d14efbff2203aa827c6d3e498/lib/berkshelf/api/site_connector/supermarket.rb#L6-L22
# module OpenURI
#   class << self
#     #
#     # The is a bug in Ruby's implementation of OpenURI that prevents redirects
#     # from HTTP -> HTTPS. That should totally be a valid redirect, so we
#     # override that method here and call it a day.
#     #
#     # Note: this does NOT permit HTTPS -> HTTP redirects, as that would be a
#     # major security hole in the fabric of space-time!
#     #
#     def redirectable?(uri1, uri2)
#       a, b = uri1.scheme.downcase, uri2.scheme.downcase
#
#       a == b || (a == 'http' && b == 'https')
#     end
#   end
# end

  # def OpenURI.redirectable?(uri1, uri2) # :nodoc:
  #   # This test is intended to forbid a redirection from http://... to
  #   # file:///etc/passwd, file:///dev/zero, etc.  CVE-2011-1521
  #   # https to http redirect is also forbidden intentionally.
  #   # It avoids sending secure cookie or referer by non-secure HTTP protocol.
  #   # (RFC 2109 4.3.1, RFC 2965 3.3, RFC 2616 15.1.3)
  #   # However this is ad hoc.  It should be extensible/configurable.
  #   uri1.scheme.downcase == uri2.scheme.downcase ||
  #   (/\A(?:http|ftp)\z/i =~ uri1.scheme && /\A(?:http|ftp)\z/i =~ uri2.scheme)
  # end
require 'yaml'


pwd = File.dirname(__FILE__)
output_path = File.join(pwd, 'episodes')
# Path and file must exists
episode_list = File.join(output_path, 'episode_list.yml')

if ARGV.shift == 'alt'
  feed_url = 'http://rubyrogues.com/podcast.rss'
else
  feed_url = 'http://feeds.feedwrench.com/RubyRogues.rss'
end

# Must be []
episodes = YAML::load(File.read(episode_list))

# Should be 1 or higher
highest_feed_number = episodes.map {|episode| episode[:feed_number].to_i }.max

xml = open(feed_url).read
doc = Nokogiri::XML(xml)
items = doc.search('item')

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
