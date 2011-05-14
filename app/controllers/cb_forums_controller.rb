class CbForumsController < ApplicationController
   before_filter :login_required, :setup,:right_nav
   before_filter :check_the_user
  # GET /cb_forums
  # GET /cb_forums.xml
  def index
    @cb_forums = CbForum.find(:all)
    if @cb_forums.length == 1
      @cb_forum = CbForum.find(@cb_forums.first)
      @topics = @cb_forum.cb_topic.paginate(:page => params[:page],:order => "updated_at DESC")
    end
  end

  # GET /cb_forums/1
  # GET /cb_forums/1.xml
  def show
    @cb_forum = CbForum.find(params[:id])
    @topics = @cb_forum.cb_topic.paginate(:page => params[:page],:order => "updated_at DESC")
     respond_to do |format|
      format.html
      format.atom
    end
  end

   def search_sort_by
     @cb_forum = CbForum.find(params[:id])

    if params[:sort] =="People"
     @topics= @cb_forum.cb_topics.find(:all, :joins => "LEFT JOIN people ON people.id=topics.person_id", :select => "topics.*, people.*", :order => "people.name ASC").paginate(:page => params[:page], :per_page =>10)
    else
    @topics = @cb_forum.cb_topics.paginate(:page => params[:page],:order => "updated_at DESC")
    end
    render :partial => "searchdetail", :layout => true, :locals => {:topics => @topics}
  end

  private

    def setup
      @body = "forum"
    end
 

end
