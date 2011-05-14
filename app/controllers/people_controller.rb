class PeopleController < ApplicationController
  
  skip_before_filter :require_activation, :only => :verify_email
  skip_before_filter :admin_warning, :only => [ :show, :update ]
  before_filter :login_required, :only => [ :index, :show, :edit, :update,
  :common_contacts ]
  before_filter :correct_user_required, :only => [ :edit, :update ]
  before_filter :setup,:right_nav
  
  def index
    @people = Person.member_profiles(params[:page_people])
    @forums = Forum.paginate(:page => params[:page_forums], :per_page => 15, :order => 'created_at DESC')
    
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @person = Person.find(params[:id])
     if params[:tabvalue]
       @tab_value=params[:tabvalue].to_i
     else
       @tab_value=0
     end
    unless @person.active? or current_person.admin?
      flash[:error] = "That person is not active"
      redirect_to home_url and return
    end
  
    @current_person = Person.find(current_person.id)
    @contacts = @current_person.connections.find(:all,:select=>'connections.contact_id')
    @contact= ''
    @contacts.each do |contact|
      if contact.contact_id == @person.id
        @contact= "true"
      end
    end
    @person_rooms = Room.paginate(:page => params[:page], :conditions=>['person_id = ?',@person.id ],:order=>'created_at DESC')
    @access_denied=''
    @contact_permission=''
    if current_person.isbanker != 0
      if @contact == "true"
        if @person.contact_permission
          @all_contact_list = @person.contacts.paginate(:page => params[:page],:per_page => RASTER_PER_PAGE)
        else
          @all_contact_list=''
          @contact_permission="false"
        end
      else
        @all_contact_list=''
      end
    elsif current_person.isbanker == 0
      if @person.isbanker != 0
         @all_contact_list=''
         @access_denied="true"
       elsif @person.isbanker == 0 && @contact== "true"
        if @person.contact_permission
        @all_contact_list = @person.contacts.paginate(:page => params[:page],:per_page => RASTER_PER_PAGE)
        else
           @all_contact_list=''
          @contact_permission="false"
        end
       else
        @all_contact_list=''
       end
      
    end
    if logged_in?
      @some_contacts = @person.some_contacts
      page = params[:page]
      @common_contacts = current_person.common_contacts_with(@person,:page => page)
      # Use the same max number as in basic contacts list.
      num_contacts = Person::MAX_DEFAULT_CONTACTS
      @some_common_contacts = @common_contacts[0...num_contacts]
      @blog = @person.blog
      @posts = @person.blog.posts.paginate(:page => params[:page])
      @galleries = @person.galleries.paginate(:page => params[:page])
      @recent_disc = Topic.find(:all, :order => "updated_at DESC", :limit => 5, :select =>"id, name, forum_id" )   
      
      
      #new changes for Roon tab 
      
      @current_person = Person.find(current_person.id)
      @contacts = @current_person.connections.find(:all,:select=>'connections.contact_id')
      @contact_id_str = ''
      @contacts.each do |contact|
        @contact_id_str += contact.contact_id.to_s+','
      end
      @contact_id_str = @contact_id_str[0..@contact_id_str.length-2]
      # @rooms = Room.paginate(:page => params[:page], :conditions=>['person_id = ? OR person_id IN ('+@contact_id_str+')',current_person.id ])
      @rooms = Room.paginate(:page => params[:page], :conditions=>['person_id = ?',current_person.id ],:order=>'created_at DESC')
       ### NEWS FEED selection
      @news_feed=NewsFeed.find(:all)
    end
    respond_to do |format|
      format.html
    end
  end

  def room_show
     @room = Room.find(params[:id])
     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @room }
    end
  end

  def choose_news_feed
    if params[:news][:feed]
       @person=Person.find(current_person)
      @person.news_id= params[:news][:feed]
      @person.save
      flash[:notice]=" #{params[:news][:feed]} News feed was successfully choosed"
    end
    redirect_to :action=>'show',:id=>current_person.id

  end

  def connected_see_contact
    if params[:connect][:contact].empty?
      flash[:error]="Choose any one of the option for Connected members to see contacts  "
     
    else
     flash[:success]=" Connected members to see contacts  was successfully updated"
      @user=current_person
      if params[:connect][:contact] == "Yes"
      @user.contact_permission=true
      @user.save
      else
      @user.contact_permission=false
      @user.save
      end
        end
      redirect_to :action=>'show',:id=>current_person.id
  end
  
  def new
    
    @menutype = "none"
    @newbanker = params[:banker]	
    @body = "register single-col"
    @person = Person.new
    @conuntires = Country.find(:all)

    respond_to do |format|
      format.html
    end
  end

  def create
    @conuntires = Country.find(:all)
    cookies.delete :auth_token
    @person = Person.new(params[:person])
    @person.country_id = params[:person][:country_id]
    respond_to do |format|
      @person.email_verified = false if global_prefs.email_verifications?
      @person.identity_url = session[:verified_identity_url]
       if session[:invitation_code]
        @person.inviter_id = Person.find_by_invitation_code(session[:invitation_code]).id
       end
      @person.save
      if @person.errors.empty?
        session[:verified_identity_url] = nil
        if session[:invitation_code] && global_prefs.email_verifications?
          @person.email_verifications.create
          flash[:notice] = "Thanks for signing up! Check your email
                             to activate your account."
           session[:invitation_code] = nil
          format.html { redirect_to(home_url) }
        elsif session[:invitation_code]
          self.current_person = @person
          flash[:notice] = "Thanks for signing up!"
          session[:invitation_code]= nil
          format.html { redirect_back_or_default(home_url) }
        else
          @person.email_verified = false if global_prefs.email_verifications?
          @person.active = false
          @person.save
          flash[:notice] = "Thanks for signing up! Your account is under waiting for approval"
           format.html { redirect_back_or_default(home_url) }
        end
      else
        @body = "register single-col"
        format.html { if @person.identity_url.blank? 
            render :action => 'select'
          else
            render :partial => "shared/personal_details.html.erb", :object => @person, :layout => 'application'
          end
        }
      end
    end
  rescue ActiveRecord::StatementInvalid
    # Handle duplicate email addresses gracefully by redirecting.
    
    redirect_to home_url
  rescue ActionController::InvalidAuthenticityToken
    # Experience has shown that the vast majority of these are bots
    # trying to spam the system, so catch & log the exception.
    warning = "ActionController::InvalidAuthenticityToken: #{params.inspect}"
    logger.warn warning
    redirect_to home_url
  end

def verify_email
  verification = EmailVerification.find_by_code(params[:id])
  if verification.nil?
    flash[:error] = "Invalid email verification code"
    redirect_to home_url
  else
    cookies.delete :auth_token
    person = verification.person
    person.email_verified = true; person.save!
    self.current_person = person
    flash[:success] = "Email verified. Your profile is active!"
    redirect_to person
  end
end

def edit
  @conuntires = Country.find(:all)
  @person = Person.find(params[:id])
  
  respond_to do |format|
    format.html
  end
end

  def update
    @conuntires = Country.find(:all)
    @person = Person.find(params[:id])
    respond_to do |format|
      case params[:type]
      when 'info_edit'
        if !preview? and @person.update_attributes(params[:person]) and @person.update_attribute("country_id", params[:person][:country_id])
          flash[:success] = 'Profile updated!'
          format.html { redirect_to(@person) }
        else
          if preview?
            @preview = @person.description = params[:person][:description]
          end
          format.html { render :action => "edit" }
        end
      when 'password_edit'
        if global_prefs.demo?
          flash[:error] = "Passwords can't be changed in demo mode."
          redirect_to @person and return
        end
        if @person.change_password?(params[:person])
          flash[:success] = 'Password changed.'
          format.html { redirect_to(@person) }
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end
  
  def common_contacts
    @person = Person.find(params[:id])
    @common_contacts = @person.common_contacts_with(current_person,
      :page => params[:page])
    respond_to do |format|
      format.html
    end
  end

  def people_by_country
         puts "************************** PEPOLE CONTROL IS CALLED *****************************"

    if params[:country_query] and request.xhr?
      @people = Person.find(:all,:conditions =>['people.country_id = ?',params[:country_query]],:select =>'people.id,people.name,countries.country_name, people.country_id,people.branch',:joins =>'left join countries on people.country_id=countries.id',:order=>'people.branch'   )
      #      @people = Person.find_all_by_country_id(params[:country_query])
      render :partial => "searchdetail", :layout => false, :locals => {:searchresults => @people}
    end
  end

  def change_photo
    @doc_attachment = Docattachment.new
  end

  def update_photo
    @collectiveparams = params[:docattachment].merge(:person_id => current_person.id,:attachable_type=>'Person',:attachable_id=>current_person.id)
    @docattachment=Docattachment.new(@collectiveparams)
    if @docattachment.save
      @oldpic = Docattachment.find(:first,:conditions=>['id <> ? and attachable_type = "Person" and attachable_id = ?',@docattachment.id,current_person.id])
      @oldpic.destroy unless @oldpic.nil?
    end
    redirect_to :controller=>'people',:action=>'show',:id=>current_person.id
  end
  
  def select
     if params[:invitation_code]
    session[:invitation_code] ||= params[:invitation_code]
     end
    @menutype = "none"
    @newbanker = params[:banker]  
    @body = "register single-col"
    @person = Person.new
    @conuntires = Country.find(:all)

    respond_to do |format|
      format.html
    end
  end
  def non_central_bank_sign_up
      if params[:invitation_code]
    session[:invitation_code] ||= params[:invitation_code]
     end
    @menutype = "none"
    @newbanker = params[:banker]
    @body = "register single-col"
    @person = Person.new
    @conuntires = Country.find(:all)

    render :partial => 'non_central'
  end

  def central_bank_sign_up
    if params[:invitation_code]
    session[:invitation_code] ||= params[:invitation_code]
     end
    @menutype = "none"
    @newbanker = params[:banker]
    @body = "register single-col"
    @person = Person.new
    @conuntires = Country.find(:all)

    render :partial => 'central_signup'
    
  end
  

def time_zone
  
  @person= Person.find(params[:id])
  @person.time_zone=  params[:people][:time_zone]
  @person.save
  redirect_to :action =>'index'
end



def edit_time_zone
  @person= Person.find(params[:id])
  if @person.update_attributes(params[:person])
    @person.time_zone=  params[:people][:time_zone]
    @person.save
   redirect_to :action =>'index'
  end
end

private

  def setup
    @body = "person"
  end
  
  def correct_user_required
    redirect_to home_url unless Person.find(params[:id]) == current_person
  end
    
  def preview?
    params["commit"] == "Preview"
  end
 end
