class MessagesController < ApplicationController
  
  before_filter :login_required, :setup,:right_nav
  before_filter :authenticate_person, :only => :show
  @message_type=''
  # GET /messages
  def index
    @messages = current_person.received_messages(params[:page])
    @message_type="recieve"
    respond_to do |format|
      format.html { render :template => "messages/index" }
    end
  end
  
  # GET /messages/sent
  def sent
    @messages = current_person.sent_messages(params[:page])
     @message_type="sent"
    respond_to do |format|
      format.html { render :template => "messages/index" }
    end
  end
  
  # GET /messages/trash
  def trash
    @messages = current_person.trashed_messages(params[:page])
     @message_type="trash"
    respond_to do |format|
      format.html { render :template => "messages/index" }
    end    
  end
  
  def show
    @message.mark_as_read if current_person?(@message.recipient)
    respond_to do |format|
      format.html
    end
  end
  
  def new    
    @message = Message.new
    @recipient = Person.find(params[:person_id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def reply
    original_message = Message.find(params[:id])
    recipient = original_message.other_person(current_person)
    @message = Message.unsafe_build(:parent_id    => original_message.id,
                                    :subject      => original_message.subject,
                                    :sender       => current_person,
                                    :recipient    => recipient)
    
    @recipient = not_current_person(original_message)
    respond_to do |format|
      format.html { render :action => "new" }
    end    
  end
  
  def create
    @message = Message.new(params[:message])
    @recipient = Person.find(params[:person_id])
    @message.sender    = current_person
    @message.recipient = @recipient
    if reply?
      @message.parent = Message.find(params[:message][:parent_id])
      redirect_to home_url and return unless @message.valid_reply?
    end
    
    respond_to do |format|
      if !preview? and @message.save
        flash[:success] = 'Message sent!'
        format.html { redirect_to messages_url }
      else
        @preview = @message.content if preview?
        format.html { render :action => "new" }
      end
    end
  end
  
  def destroy
    @message = Message.find(params[:id])
    if @message.trash(current_person)
      flash[:success] = "Message trashed"
    else
      # This should never happen...
      flash[:error] = "Invalid action"
    end
    
    respond_to do |format|
      format.html { redirect_to messages_url }
    end
  end
  
  def undestroy
    @message = Message.find(params[:id])
    if @message.untrash(current_person)
      flash[:success] = "Message restored to inbox"
    else
      # This should never happen...
      flash[:error] = "Invalid action"
    end
    respond_to do |format|
      format.html { redirect_to messages_url }
    end
  end
  
 def search_sort_by
         puts "************************** Messages sort_by is  CALLED *****************************"
    if params[:sort]
       if params[:sort] == "People"
         if params[:message_type] =="recieve"
              @message_type=params[:message_type]
              @messages = Message.find_by_sql("SELECT communications.*, people.*,(select name from people where people.id = communications.sender_id) as people_name FROM `communications` LEFT JOIN people ON people.id=communications.recipient_id WHERE (communications.recipient_id = #{current_person.id}) AND ( (`communications`.`type` = 'Message' ) ) ORDER BY people_name ASC;").paginate(:page => params[:page], :per_page =>10)
          elsif params[:message_type] == "sent"
             @message_type=params[:message_type]
              @messages = Message.find_by_sql("SELECT communications.*, people.*,(select name from people where people.id = communications.recipient_id) as people_name FROM `communications` LEFT JOIN people ON people.id=communications.sender_id WHERE (communications.sender_id = #{current_person.id}) AND ( (`communications`.`type` = 'Message' ) ) ORDER BY people_name ASC;").paginate(:page => params[:page], :per_page =>10)
           else
              @message_type=params[:message_type]
              @messages= Message.find(:all, :joins => "LEFT JOIN people ON people.id=communications.recipient_id and people.id=communications.sender_id",:conditions => "sender_deleted_at != 'NULL' or recipient_deleted_at != 'NULL'", :select => "communications.*, people.*", :order => "people.name ASC").paginate(:page => params[:page], :per_page =>10)
           end
       elsif params[:sort] == "Date"
           puts "************************** DATE IS CALLED *****************************"
         if params[:message_type] == "recieve"
       @messages = current_person.received_messages(params[:page])
       elsif  params[:message_type] == "sent"
         @messages = current_person.received_messages(params[:page])
       else
         current_person.trashed_messages(params[:page])
         end
       else
           @messages = current_person.received_messages(params[:page])
      end
    end
     #render :partial => "searchdetail",:locals => {:road_shows => @road_shows}
       render :partial => "searchdetail", :layout => true, :locals => {:road_shows => @messages},:page =>params[:page]
end
  
  def new_message
    @people = Person.find_by_sql("select * from people where deactivated=false")
    respond_to do |format|
      format.html
    end
  end
  
  def create_message
      
    if params["commit"] == "Preview"
      if params[:message]
        params[:message][:receipent] ||= []
      if !params[:subject].empty? and !params[:content].empty? 
        params[:message][:receipent] ||= []
        if params[:message][:receipent].size > 0
       @email=''
       @recep=params[:message][:receipent]
       @recep.each do |r|
          @recipient = Person.find(r)
          @email<<@recipient.email<<";"
       end

      @message = Message.new
      @message.subject= params[:subject]
      @message.content= params[:content]
      @message.sender = current_person
     # @preview = params[:content] if preview?
       #@people = Person.find_by_sql("select * from people where deactivated=false")
      render :action => "preview_message",:locals =>{:recep=>@recep}
        else
          flash[:error] = 'Please choose the reciepient names '
           redirect_to :action => "new_message"
        end
      else
        flash[:error] = 'Please enter mail subject or content'
           redirect_to :action => "new_message"
      end
      else
        flash[:error] = 'Please choose the reciepient names '
           redirect_to :action => "new_message"
      end
    else
      if params[:message]
       params[:message][:receipent] ||= []
      if params[:message][:receipent].size > 0
       params[:message][:receipent].each do |recip|
          @message = Message.new
          @message.subject= params[:subject]
          @message.content= params[:content]
          @message.sender = current_person
          @recipient = Person.find(recip)
          @message.recipient = @recipient
          @message.save
        end
        if @message.save
          flash[:success] = 'Message sent!'
          redirect_to messages_url
        else
           flash[:error] = 'Please give the mail subject or content'
           redirect_to :action => "new_message"
        end
      else
        flash[:error] = 'Please select atlease one Recipient!'
        redirect_to :action => "new_message"
      end
      else
        flash[:error] = 'Please select atlease one Recipient!'
        redirect_to :action => "new_message"

    end
    end
  end
  def send_message
    if params[:recep]
        params[:recep].each do |recip|
          @message = Message.new
          @message.subject= params[:subject]
          @message.content= params[:content]
          @message.sender = current_person
          @recipient = Person.find(recip)
          @message.recipient = @recipient
          @message.save
        end
        flash[:success]="Message Sent"
        redirect_to messages_url
    else
      flash[:error]="Message has not been sent"
       redirect_to :action =>'new_message'
    end
  end
  
  
  private
  
  def setup
    @body = "messages"
  end
  
  def authenticate_person
    @message = Message.find(params[:id])
    unless (current_person == @message.sender or
            current_person == @message.recipient)
      redirect_to login_url
    end
  end
  
  def reply?
    not params[:message][:parent_id].nil?
  end
  
  # Return the proper recipient for a message.
  # This should not be the current person in order to allow multiple replies
  # to the same message.
  def not_current_person(message)
    message.sender == current_person ? message.recipient : message.sender
  end
  
  def preview?
    params["commit"] == "Preview"
  end
  
end
