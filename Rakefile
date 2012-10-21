task :social do
  require 'rubygems'
  require 'jekyll'

  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)

  posts = []

  posts += twitter site.config['twitter_id'] if site.config.has_key? 'twitter_id'
  posts += delicious site.config['delicious'] if site.config.has_key? 'delicious'
  posts += pinboard site.config['pinboard'] if site.config.has_key? 'pinboard'
  posts += github site.config['github'] if site.config.has_key? 'github'
  posts += lastfm site.config['lastfm'] if site.config.has_key? 'lastfm'
  posts += flickr site.config['flickr_id'] if site.config.has_key? 'flickr_id'
  posts += vimeo site.config['vimeo'] if site.config.has_key? 'vimeo'
  posts += instagram site.config['instagram'] if site.config.has_key? 'instagram'

  posts.sort! { |a,b| b['ts'] <=> a['ts'] }

  prev_title = ""
  posts.select! { |item|
    prev_title != ( prev_title = item['title'] )
  }

  posts = posts[0, 75]

  date = nil
  for i in 0..posts.length-1
    el = posts[i]

    el['previousSibling'] = i > 0 && posts[i-1]['feed'] == el['feed'] ? 'yes' : 'no'
    el['nextSibling'] = i < posts.length-1 && posts[i+1]['feed'] == el['feed'] ? 'yes' : 'no'

    print_date = 'no'
    if el['datetime'].to_date != date
      date = el['datetime'].to_date
      print_date = 'yes'
    end

    el['content']['---'] = "---\nprint-date: #{print_date}\nprevious-sibling: #{el['previousSibling']}\nnext-sibling: #{el['nextSibling']}"
    save("./_posts/#{el['slug']}.markdown", el['content'])
  end
end

def items(url, query="rss/channel/item")
  require 'open-uri'
  require 'rexml/document'

  bf = open(url).read

  doc = REXML::Document.new(bf)
  coll = []

  doc.elements.each(query) do |el|
    item = {}
    el.children.each do |node|
      if node.respond_to? 'name'
        item[node.name] = node.text || node
      end
    end

    yield item if block_given?

    if item.has_key? "published"
      #2012-08-03T18:31:04-07:00
      item['datetime'] = DateTime.strptime(item['published'], '%Y-%m-%dT%H:%M:%S')
    end

    if item.has_key? "date"
      #2012-08-15T05:08:35+00:00
      item['datetime'] = DateTime.strptime(item['date'], '%Y-%m-%dT%H:%M:%S')
    end

    if item.has_key? "pubDate"
      # Thu, 29 Oct 2009 09:44:00 -0400
      item['datetime'] = DateTime.strptime(item['pubDate'], '%a, %d %h %Y %H:%M:%S')
    end

    date = (item['datetime'].to_time + rand(60)).to_datetime
    slug = date.strftime '%Y-%m-%d-%H%M%S-' 
    
    if item['title'].length > 0
      slug += item['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')[0, 20]
      item['title'].gsub!('"','\"')
    end

    item['datetime'] = date
    item['date'] = date.strftime '%Y-%m-%d %H:%M:%S'
    item['ts'] = date.to_time.to_i
    item['slug'] = slug

    coll << item
  end

  return coll
end

def save(filename, entry)
  File.open(filename, 'w+') do |file|
    file.puts entry
  end
end

def twitter(id)
  puts "Fetching Twitter timeline. User Id: #{id}"

  tweets = items "https://api.twitter.com/1/statuses/user_timeline.rss?screen_name=#{id}"
  tweets.each do |tweet|
    tweet['feed'] = :twitter
    tweet['content'] = <<eos
---
layout: post
title: "#{tweet['title']}"
date: #{tweet['date']}
link: "#{tweet['link']}"
twitter: yes
---
eos

  end

  return tweets

end

def delicious(username)
  puts "Fetching recently added Delicious bookmarks. User Id: #{username}"

  links = items "http://feeds.delicious.com/v2/rss/#{username}?count=100"
  links.each do |link|
    link['feed'] = :delicious
    link['content'] = <<eos
---
layout: post
title: "#{link['title']}"
date: #{link['date']}
link: "#{link['link']}"
delicious: yes
---
eos
  end

  return links

end

def github(username)
  puts "Fetching #{username}'s Github Activities"

  activities = items("https://github.com/#{username}.atom", "feed/entry") { |item|
    item['link'] = item['link'].attributes['href']
    item['datetime'] = DateTime.strptime(item['published'], '%Y-%m-%dT%H:%M:%SZ')
  }



  activities.each do |activity|
    activity['feed'] = :github
    activity['content'] = <<eos
---
layout: post
title: "#{activity['title']}"
date: #{activity['date']}
link: "#{activity['link']}"
github: yes
---
eos

  end

  return activities

end

def flickr(id)
  puts "Fetching #{id}'s Flickr"

  photos = items "http://api.flickr.com/services/feeds/photos_public.gne?id=#{id}&lang=en-us&format=rss_200"

  photos.each do |photo|
    thumbnail = photo['thumbnail'].attributes['url'].gsub("_s.jpg","_q.jpg")
    description = ( !photo['description'].include? "a href=" ) ?  photo['description'] : "&nbsp;"
    photo['feed'] = :flickr
    photo['content'] = <<eos
---
layout: flickr
title: "#{photo['title']}"
date: #{photo['date']}
link: "#{photo['link']}"
thumbnail: "#{thumbnail}"
flickr: yes
---
<img src="#{thumbnail}" />
eos

  end

  return photos

end

def instagram(username)
  puts "Fetching #{username}'s Instagram Photos"

  photos = items "http://followgram.me/#{username}/rss"

  photos.each do |photo|
    link = photo['description'].scan(/http?:\/\/[\S]+\.jpg/)[0]
    thumbnail = link.gsub('_7.jpg','_5.jpg')
    photo['feed'] = :instagram
    photo['content'] = <<eos
---
layout: instagram
title: "#{photo['title']}"
date: #{photo['date']}
link: "#{link}"
thumbnail: "#{thumbnail}"
instagram: yes
---
<img src="#{thumbnail}" />
eos
  end

  return photos

end

def lastfm(username)
  puts "Fetching #{username}'s Recent Loved Tracks"
  tracks = items "http://ws.audioscrobbler.com/2.0/user/#{username}/lovedtracks.rss"
  tracks.each do |track|
    track['feed'] = :lastfm
    track['content'] = <<eos
---
layout: post
title: "&#9829; #{track['title']}"
date: #{track['date']}
link: "#{track['link']}"
lastfm: yes
---
eos
  end

  return tracks
end

def pinboard(username)
  puts "Fetching recently added Pinboard bookmarks. User Id: #{username}"

  links = items("http://feeds.pinboard.in/rss/u:#{username}/", "rdf:RDF/item")

  links.each do |link|
    link['feed'] = :pinboard
    link['content'] = <<eos
---
layout: post
title: "#{link['title']}"
date: #{link['date']}
link: "#{link['link']}"
pinboard: yes
---
eos
  end

  return links

end

def vimeo(username)
  puts "Fetching #{username}'s Videos on Vimeo"
  videos = items("http://vimeo.com/#{username}/videos/rss"){ |item|
    item['player'] = item['enclosure'].attributes['url']
  }
  videos.each do |video|
    id = video['link'].gsub('http://vimeo.com/','')
    video['feed'] = :vimeo
    video['content'] = <<eos
---
layout: post
title: "#{video['title']}"
date: #{video['date']}
link: "#{video['link']}"
vimeo_id: #{id}
vimeo: yes
---
eos
  end

  return videos
end
