class ForumsController < ApplicationController
  
  before_filter :login_required, :setup,:right_nav

  def index
    @forums = Forum.find(:all)
    if @forums.length == 1
    #  redirect_to forum_url(@forums.first) and return
      @forum = Forum.find(@forums.first)
      @topics = @forum.topics.paginate(:page => params[:page],:order => "updated_at DESC")
    end
  end

  def show
    @forum = Forum.find(params[:id])
    @topics = @forum.topics.paginate(:page => params[:page],:order => "updated_at DESC")
    
     respond_to do |format|
      format.html
      format.atom
    end
  end
  def search_sort_by
    
     @forum = Forum.find(params[:id])

    if params[:sort] =="People"
     @topics= @forum.topics.find(:all, :joins => "LEFT JOIN people ON people.id=topics.person_id", :select => "topics.*, people.*", :order => "people.name ASC").paginate(:page => params[:page], :per_page =>10)
    else
    @topics = @forum.topics.paginate(:page => params[:page],:order => "updated_at DESC")
    end
    render :partial => "searchdetail", :layout => true, :locals => {:topics => @topics}
  end

  private
  
    def setup
      @body = "forum"
    end
end
