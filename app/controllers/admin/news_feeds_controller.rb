class Admin::NewsFeedsController < ApplicationController
  def index
    @news_feed=NewsFeed.find(:all)
    
  end
  def new
    @news_feed = NewsFeed.new
     respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news_feed }
    end
  end
def create
  if params[:news_feed] && !params[:news_feed].empty?
  @news_feed = NewsFeed.new(params[:news_feed])
  end
  if params[:accept]
   
    @news =NewsFeed.find(:first,:conditions =>['set_default=?',true])
    if @news
    @news.set_default=false
    @news.save
    end
    @news_feed.set_default=true
  end
  if @news_feed.save
   respond_to do |format|
      flash[:notice] = 'News Feed was successfully created.'
        format.html {redirect_to :action=>'index'}
      format.xml  { render :xml => @news_feed }
     
   end
  end
end

def edit
  @news_feed=NewsFeed.find(params[:id])
end
def update_addr
  puts " ***************************************** UPDATE IS CALLED ******************************"
  @news_feed=NewsFeed.find(params[:id])
@news =NewsFeed.find(:first,:conditions =>['set_default=?',true])
  if params[:accept]
    if @news
    @news.set_default=false
    @news.save
    end
    @news_feed.set_default=true
    @news_feed.save
  else
    @news_feed.set_default=false
    @news_feed.save
  end
  if params[:news_feed]
  @news_feed.update_attributes(params[:news_feed])
  flash[:notice] = 'News Feed was successfully updated.'
  redirect_to :action=>'index'
  end
end
def delete
  @news_feed=NewsFeed.find(params[:id])
  @person=Person.find(:all,:conditions =>['news_id = ?',params[:id]])
  @new=NewsFeed.find(:first,:conditions =>['set_default=?',true])
  if @new
    if @person.size > 0
    @person.each do |p|
      p.news_id = @new.id
      p.save
    end
  end
  else
  if @person.size > 0
    @person.each do |p|
      p.news_id = nil
      p.save
    end
  end
  end
  @news_feed.destroy
  flash[:notice] = 'News Feed was Deleted successfully '
    redirect_to :action=>'index'
end
end
