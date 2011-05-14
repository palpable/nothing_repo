class RoadShowsController < ApplicationController
   before_filter :check_the_user,:right_nav
  #before_filter :is_banker?
  #The above line is commend by palani by the instruction of Shawn be casue Non-central banker also have the option Roadshow
  def index
    @current_person = Person.find(current_person.id)
    @contacts = @current_person.connections.find(:all,:select=>'connections.contact_id')
    @contact_id_str = ''
    @contacts.each do |contact|
      @contact_id_str += contact.contact_id.to_s+','
    end
    @contact_id_str = @contact_id_str[0..@contact_id_str.length-2]
    #@road_shows = RoadShow.paginate(:page => params[:page], :conditions=>['person_id = ? OR person_id IN ('+@contact_id_str+')',current_person.id ],:order=>'created_at DESC')
    @road_shows = RoadShow.paginate(:page => params[:page], :conditions=>["person_id = ? OR person_id IN (?)", current_person.id, @contacts.collect(&:id)],:order=>'created_at DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @road_shows }
    end
  end
  
  # GET /road_shows/1
  # GET /road_shows/1.xml
  def show
    @road_show = RoadShow.find(params[:id])
    session[:road_show_id] = @road_show.id
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @road_show }
    end
  end
  
  # GET /road_shows/new
  # GET /road_shows/new.xml
  def new
    @road_show = RoadShow.new
    @docattachment = Docattachment.new
    @youtubeurl = YoutubeULink.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @road_show }
    end
  end
  
  # GET /road_shows/1/edit
  def edit
    @road_show = RoadShow.find(params[:id])
  end
  
  # POST /road_shows
  # POST /road_shows.xml
  def create
    @road_show = RoadShow.new(params[:road_show])
    @road_show.person_id = current_person.id
    if params[:accept]
      @road_show.is_public =true
    end
    respond_to do |format|
      if @road_show.save
        if params[:youtube_u_link]
          @youtubeurl = YoutubeULink.new(params[:youtube_u_link])
          @youtubeurl.road_show_id = @road_show.id
          @youtubeurl.save
        elsif params[:flvu_u_url]
          @flvurl = FlvuUUrl.new(params[:flvu_u_url])
          @flvurl.road_show_id = @road_show.id
          @flvurl.save
        elsif params[:docattachment]
          @collectiveparams = params[:docattachment].merge(:person_id => current_person.id,:attachable_type=>'RoadShow',:attachable_id=>@road_show.id)
          @docattachment=Docattachment.new(@collectiveparams)
          @docattachment.save
          @media=@docattachment.content_type
          @temp=@media.gsub(/\/.*/,'')
            if @temp
          if @temp == "video"

            "puts  *********************************** BEFORE CONVERT *********************************"
          @docattachment.convert
        end
           end
        end
        session[:road_show_id] = @road_show.id
        flash[:notice] = 'Road Show successfully created.'
        format.html {redirect_to :action=>'road_show_message',:id =>@road_show.id}
        # redirect_to :action =>'message',:id =>@road_show.id
        format.xml  { render :xml => @road_show, :status => :created, :location => @road_show }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @road_show.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /road_shows/1
  # PUT /road_shows/1.xml
  def update
    @road_show = RoadShow.find(params[:id])
    
    respond_to do |format|
      if @road_show.update_attributes(params[:road_show])
        flash[:notice] = 'RoadShow was successfully updated.'
        format.html { redirect_to(@road_show) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @road_show.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /road_shows/1
  # DELETE /road_shows/1.xml
  def destroy
    @road_show = RoadShow.find(params[:id])
    @road_show.youtube_u_links.each do |video|
      video.destroy
    end
    @road_show.flvu_u_urls.each do |video|
      video.destroy
    end
    @road_show.docattachments.each do |attachment|
      attachment.destroy
    end
    @road_show.destroy
    
    respond_to do |format|
      format.html { redirect_to(road_shows_url) }
      format.xml  { head :ok }
    end
  end
  
  def youtubeurl_add
    @utubelink = YoutubeULink.new
    #  rescue
    
    url = params[:addr].split('=')
    
    if  url[1] != nil
      uniqid = url[1].split('&')
      @utubelink.uniqueid = uniqid[0]
      @utubelink.addr=params[:addr]
      @urldata = YouTube.find_by_id(url[1])
      @utubelink.title=@urldata.title
      @utubelink.person_id = current_person.id
      @utubelink.save
      flash[:notice]='youtube URL saved successfully'
    else
      flash[:notice]='kindly enter youtube proper url'
    end
    redirect_to :controller=>'road_shows',:action=>'index'
  end
  
  def flvurl_add
    @flvurl = FlvuUUrl.new
    @flvurl.addr=params[:addr]
    @flvurl.person_id = current_person.id
    @flvurl.save
    flash[:notice]='FLV URL saved successfully'
    redirect_to :controller=>'road_shows',:action=>'index'
  end
  def partialrenderer
    
    @youtubelink = YoutubeULink.new
    @flvurl = FlvuUUrl.new
    @docattachment = Docattachment.new
    render :partial=>params[:value]
  end
  def road_show_message
    
    if params[:id]
      @road_show=RoadShow.find(params[:id])
    end
    if @road_show
      puts " ************************* @ ROAD SHOW Object is not Null *****************"
      if @road_show.is_public
        puts " ************************* @ ROAD SHOW Object is PUBLIC *****************"
        @people = Person.find_by_sql("select * from people where deactivated=false")
       
      else
        puts " ************************* @ ROAD SHOW Object is NOT PUBLIC *****************"
       @people = Person.find_by_sql("select * from people where isbanker=true and deactivated=false")
      end
    end
  end
  def road_show_message_create
    #    @people = Person.find(:all)
    if params[:message]
      params[:message][:receipent] ||= []
      puts " *************************************** ARRAY SIZE *************************** #{params[:message][:receipent].size}"
      if params[:message][:receipent].size > 0
        params[:message][:receipent].each do |msg|
          @message = Message.new
          @message.subject= 'New Road Show Created'
          @message.content= 'Click <a href="/road_shows/show/'+session[:road_show_id].to_s+'">Here </a>to View'
          @recipient = Person.find(msg)
          @message.sender= current_person
          @message.recipient = @recipient
          @message.save
          puts"**********************************************AFTER SAVE**************************"
          flash[:notice]='Road Show was successfully sent'
        end
      end
    else
      puts"********************************* Before Redirect"   
      flash[:error]='Please select atlease one Recipient to send Mail'
    end 
    redirect_to :action =>"road_show_message",:id =>session[:road_show_id]
  end
 def search_sort_by
         puts "************************** ROAD_SHOW sort_by is  CALLED *****************************"

    if params[:sort] 
       if params[:sort] == "People"
        #redirect_to :controller =>'search',:action =>'index',:q =>params[:sort]
       @road_shows= RoadShow.find(:all, :joins => "LEFT JOIN people ON people.id=road_shows.person_id", :select => "road_shows.*, people.*", :order => "people.name ASC").paginate(:page => params[:page], :per_page =>10)
      
       else
       @road_shows=RoadShow.find(:all,:order=>'created_at DESC').paginate(:page => params[:page], :per_page =>10)
       puts "**************************ROAD_SHOW OBJECT ******************************* #{@road_shows.inspect}  "
      
       end
    end
     #render :partial => "searchdetail",:locals => {:road_shows => @road_shows}
       render :partial => "searchdetail", :layout => true, :locals => {:road_shows => @road_shows},:page =>params[:page]
end

  private
  
  def is_banker?
    unless current_person.isbanker?
      flash[:error] = "You must be a central banker to access this page"
      redirect_to home_url
    end
    true
  end
  
end
