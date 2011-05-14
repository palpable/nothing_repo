class Admin::PeopleController < ApplicationController
  
  before_filter :login_required, :admin_required
  
  def index
    @people = Person.paginate(:all, :page => params[:page], :order => :name)
    @people.each do |p|
  
    end
    @people_list = Person.find(:all)
  end
  
  def update
    @person = Person.find(params[:id])
    if current_person?(@person)
      flash[:error] = "Action failed."
    else
      @person.toggle!(params[:task])
      flash[:success] = "#{CGI.escapeHTML @person.name} updated."
    end
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
  
  def first_time_activation
    @active = Person.find_by_id(params[:id])
    @active.active = true
    if @active.save
      PersonMailer.deliver_user_activation(@active)
    end
    redirect_to :action=>"index"
  end

  def delete_person
    @people_list = Person.find(:all)
  end

  def delete_list_people
    params[:message][:receipent].each do |a|
      @delete_people = Person.delete_all("id = #{a}")
      @delete_activities = Activity.delete_all("person_id = #{a}" )
      @delete_blog = Blog.delete_all("person_id = #{a}" )
      @delete_comment = Comment.delete_all("commenter_id = #{a}" )
      @delete_communication = Communication.delete_all("sender_id = #{a} OR recipient_id = #{a}" )
      @delete_connection = Connection.delete_all("person_id = #{a} OR contact_id = #{a}" )
      @delete_event_attendee = EventAttendee.delete_all("person_id = #{a}" )
      @delete_event = Event.delete_all("person_id = #{a}" )
      @delete_feed = Feed.delete_all("person_id = #{a}" )
      @delete_flv_url = FlvuUUrl.delete_all("person_id = #{a}" )
      @delete_gallery = Gallery.delete_all("person_id = #{a}" )
      @delete_photo = Photo.delete_all("person_id = #{a}" )
      @delete_post = Post.delete_all("person_id = #{a}" )
      @delete_road_show = RoadShow.delete_all("person_id = #{a}" )
      @delete_room = Room.delete_all("person_id = #{a}" )
      @delete_youtube_link = YoutubeULink.delete_all("person_id = #{a}" )
      @delete_topic = Topic.delete_all("person_id = #{a}" )
    end
    redirect_to :action => "index"
  end  
end
