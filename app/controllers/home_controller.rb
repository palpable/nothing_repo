class HomeController < ApplicationController

  skip_before_filter :require_activation
  before_filter :right_nav,:only => [ :invite_user, :invite ]
  def index
    @body = "home"
    @topics = Topic.find_recent
    @members = Person.find_recent
    #puts "********************************** SET SESSION VALUE  IN HOME ********************************* #{params[:invitation_code]}"
    #session[:invitation_code] ||= params[:invitation_code]
    if logged_in?
      source=''
      @feed = current_person.feed
      @some_contacts = current_person.some_contacts
      @requested_contacts = current_person.requested_contacts
      @forums = Forum.paginate(:page => params[:page_forums], :per_page => 15, :order => 'created_at DESC')
      if current_person.news_id
        @news_feed =NewsFeed.find(current_person.news_id)
        source = "#{@news_feed.addr}" # url or local file
        content = "" # raw content of rss feed will be loaded here
        open(source) do |s|
          content = s.read
        end
        rss = RSS::Parser.parse(content, false)
        @link = rss.channel.link
        @title = rss.channel.title
        @items = rss.channel.items[0..4] # just use the first five items
      
      else
        @default =NewsFeed.find(:first,:conditions =>['set_default = ?',true])
        if @default
          source = "#{@default.addr}" # url or local file
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
     
    else
      redirect_to '/landing'
      return
    end
    
    respond_to do |format|
      format.html
      format.atom
    end
    
  end
  
  def message

    if params[:username] && params[:message]
      PersonMailer.deliver_report_message(current_person,params[:username],params[:message])
      flash[:success]=" The message was successfully sent to site admin"
    end
    redirect_to  home_url
  end

  def invite_user
    if current_person.isbanker == 0
      start_date =Date.parse("01 Date.today.month Date.today.year")
      end_date =start_date + 1.month
      @invite_count=InvitationCount.find(:all ,:conditions =>["user_id= ? and created_at >=? and created_at < ?",current_person.id,start_date,end_date ])
      if @invite_count.length >=2
        flash[:notice] = "You cann't Invite the people more than twice per month"
        redirect_to :action => 'index'
      end
    end
    @recipients=[]
  end
 
  def invite
    @user = current_person
    @recipients, @errors, @bad_recipients, @good_recipients = [], [], [], []
    if request.post?
      if params[:recipients].nil?
        flash.now[:error] = "You didn't check any friends to receive your invitation. Please try again."
        redirect_to :controller=>'home',:action=>'invite_user'
      end
      logger.info("#####################################################")
      logger.info(params[:recipients])
      if params[:recipients].is_a? HashWithIndifferentAccess
        @recipients = params[:recipients].collect{|k,v| v}
      else
        @recipients = params[:recipients].split(/\n|;|,/).collect {|r| r.strip}
      end
      logger.info(@recipients)
      logger.info("#####################################################")
      @message = params[:message]
      @recipients.each do |r|
        unless r =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
          @errors << "#{r} is not a valid e-mail address."
          @bad_recipients << r
        else
          if Person.find_by_email(r)
            @errors << "#{r} is already a member."
            @bad_recipients << r
          else
            @good_recipients << r
          end
        end        
      end

      if @good_recipients.empty?
        @errors << "(You must enter at least one valid e-mail address to send an invitation.)"
        flash[:error] = "#{@errors.join("<br />")}"
      elsif @good_recipients.length > 5
        @errors << "(Only 5 invitations can be send at this moment.)"
        flash[:error] = "#{@errors.join("<br />")}"
      else
        @host=request.host
        @good_recipients.each {|recipient| PersonMailer.deliver_user_invitation(@user, recipient, @message,@host)}
        # redirect_to :action => "invite"
        flash[:notice] = "Invitations were sent to #{@good_recipients.join(', ')}."
        flash[:error] = "#{@errors}" unless @errors.empty?
        @recipients = @bad_recipients
      end

      if current_person.isbanker == 0
        @invite_entry=InvitationCount.new
        @invite_entry.user_id=current_person.id
        @invite_entry.save
      end
    end
    redirect_to :controller=>'home',:action=>'invite_user'
  end
end
