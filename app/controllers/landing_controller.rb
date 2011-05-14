class LandingController < ApplicationController
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'


  def index
    # This grabs the 5 most recently updated forum posts. 
	  @recent_disc = Topic.find(:all, :order => "updated_at DESC", :limit => 5, :select =>"id, name" )
	  # This shows the number of members currently registered for the site.
	  @members = Person.count(:all)
    @news_feed =NewsFeed.first(:conditions =>['set_default=?',true])
	  if @news_feed
      source = "#{@news_feed.addr}" # url or local file
      content = "" # raw content of rss feed will be loaded here
      open(source) do |s|
        content = s.read
      end
      rss = RSS::Parser.parse(content, false)
      @link = rss.channel.link
      @title = rss.channel.title
      @items = rss.channel.items[0..4] # just use the first five items
    end
  end

  def not_a_member
    
  end

end
