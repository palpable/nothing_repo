class RoomsController < ApplicationController
     before_filter :right_nav
   def index
    @current_person = Person.find(current_person.id)
    @contacts = @current_person.connections.find(:all,:select=>'connections.contact_id')
    @contact_id_str = ''
    @contacts.each do |contact|
      @contact_id_str += contact.contact_id.to_s+','
    end
    @contact_id_str = @contact_id_str[0..@contact_id_str.length-2]
   # @rooms = Room.paginate(:page => params[:page], :conditions=>['person_id = ? OR person_id IN ('+@contact_id_str+')',current_person.id ],:order=>'created_at DESC')
     #@rooms = Room.paginate(:page => params[:page], :conditions=>['person_id = ?',current_person.id ],:order=>'created_at DESC')
     @rooms=Room.find(:all,:conditions=>['person_id = ?',current_person.id ],:order=>'created_at DESC').paginate(:page => params[:page], :per_page =>6)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rooms }
    end
  end
  
  
    def edit
    
    @room= Room.find(params[:id])
  end
  
  
    def update
     @room = Room.find(params[:id])
    
    respond_to do |format|
      if  @room.update_attributes(params[:room])
        flash[:notice] = 'Room Item was successfully updated.'
        format.html { redirect_to(:controller =>'people',:action=>'show',:id =>@room.person_id,:tabvalue =>"1") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml =>  @room.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
    def new
    @room = Room.new
    @docattachment = Docattachment.new
    @youtubeurl = YoutubeULink.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @room }
    end
  end
  
  
  
    def create
    @room = Room.new(params[:room])
    @room.person_id = current_person.id
    if params[:accept]
      @room.is_public =true
    end
    respond_to do |format|
      if @room.save
        if params[:youtube_u_link]
          @youtubeurl = YoutubeULink.new(params[:youtube_u_link])
          @youtubeurl.room_id = @room.id
          @youtubeurl.save
        elsif params[:flvu_u_url]
          @flvurl = FlvuUUrl.new(params[:flvu_u_url])
          @flvurl.room_id = @room.id
          @flvurl.save
        elsif params[:docattachment]
          @collectiveparams = params[:docattachment].merge(:person_id => current_person.id,:attachable_type=>'Room',:attachable_id=>@room.id)
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
        session[:room_id] = @room.id
        flash[:notice] = 'Room Item successfully created.'
        format.html {redirect_to :action=>'room_show_message',:id =>@room.id}
        # redirect_to :action =>'message',:id =>@road_show.id
        format.xml  { render :xml => @room, :status => :created, :location => @room }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @room.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
    def show
    @room = Room.find(params[:id])
    session[:room_id] = @room.id
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @room }
    end
  end
 
  
   def destroy
    @room = Room.find(params[:id])
   @room .youtube_u_links.each do |video|
      video.destroy
    end
    @room .flvu_u_urls.each do |video|
      video.destroy
    end
    @room .docattachments.each do |attachment|
      attachment.destroy
    end
   @room .destroy
    
    respond_to do |format|
      format.html { redirect_to(:controller =>'people',:action=>'show',:id =>@room.person_id,:tabvalue =>"1") }
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
    redirect_to :controller=>'rooms',:action=>'index'
  end
  
  def flvurl_add
    @flvurl = FlvuUUrl.new
    @flvurl.addr=params[:addr]
    @flvurl.person_id = current_person.id
    @flvurl.save
    flash[:notice]='FLV URL saved successfully'
    redirect_to :controller=>'rooms',:action=>'index'
  end
  
  
    def partialrenderer
    p 'LLLLLLLLLLLLLLLLLLLLLLLLLLLLL'
    @youtubelink = YoutubeULink.new
    @flvurl = FlvuUUrl.new
    @docattachment = Docattachment.new
    render :partial=>params[:value]
  end
  
  
  
   def room_message_create
        @people = Person.find(:all)
    if params[:message]
      params[:message][:receipent] ||= []
      puts " *************************************** ARRAY SIZE *************************** #{params[:message][:receipent].size}"
      if params[:message][:receipent].size > 0
        params[:message][:receipent].each do |msg|
          @message = Message.new
          @message.subject= 'New Room Item Created'
          @message.content= 'Click <a href="/rooms/show/'+session[:room_id].to_s+'">Here </a>to View'
          @recipient = Person.find(msg)
          @message.sender= current_person
          @message.recipient = @recipient
          @message.save
          puts"**********************************************AFTER SAVE**************************"
          flash[:notice]='Room Item was successfully sent'
        end
      end
    else
      puts"********************************* Before Redirect"   
      flash[:error]='Please select atlease one Recipient to send Mail'
    end 
    redirect_to :action =>"room_show_message",:id =>session[:room_id]
  end
  
  
    def room_show_message
        if params[:id]
      @room=Room.find(params[:id])
    end
    if @room
      puts " ************************* @ ROAD SHOW Object is not Null *****************"
      if @room.is_public
        puts " ************************* @ ROAD SHOW Object is PUBLIC *****************"
        @people = Person.find_by_sql("select * from people where deactivated=false")
       
      else
        puts " ************************* @ ROAD SHOW Object is NOT PUBLIC *****************"
       @people = Person.find_by_sql("select * from people where isbanker=true and deactivated=false")
      end
    end
  end
  
   def search_sort_by
       p 'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
    if params[:sort] 
       if params[:sort] == "People"
        #redirect_to :controller =>'search',:action =>'index',:q =>params[:sort]
       @rooms= Room.find(:all, :joins => "LEFT JOIN people ON people.id=rooms.person_id", :select => "rooms.*, people.*", :order => "people.name ASC").paginate(:page => params[:page], :per_page =>10)
      
       else
       @rooms=Room.find(:all,:order=>'created_at DESC').paginate(:page => params[:page], :per_page =>10)
       puts "**************************ROAD_SHOW OBJECT ******************************* #{@rooms.inspect}  "
      
       end
    end
     #render :partial => "searchdetail",:locals => {:road_shows => @road_shows}
       render :partial => "searchdetail", :layout => true, :locals => {:rooms => @rooms},:page =>params[:page]
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
