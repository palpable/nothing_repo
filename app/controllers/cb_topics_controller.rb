class CbTopicsController < ApplicationController
 before_filter :login_required
  before_filter :admin_required, :only => [:edit, :update, :destroy]
  before_filter :setup,:right_nav
   before_filter :check_the_user

  def index
    redirect_to cb_forum_url(params[:cb_forum_id])
  end

  def show
    @topic = CbTopic.find(params[:id])
    @posts = @topic.cb_post

    respond_to do |format|
      format.html
      format.atom
    end
  end

  def new
    @topic = CbTopic.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @cb_topic = CbTopic.find(params[:id])
  end

  def create
    
    @topic = @cb_forum.cb_topic.new(params[:cb_topic])
    @topic.person = current_person

    respond_to do |format|
      if @topic.save
        flash[:success] = 'Topic was successfully created.'
        format.html { redirect_to cb_forum_cb_topic_path(@cb_forum, @topic) }
      else
           flash[:success] = 'Topic was not successfully created.'
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @topic = CbTopic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:cb_topic])
        flash[:success] = 'Topic was successfully updated.'
        format.html { redirect_to cb_forum_url(@cb_forum) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @topic = CbTopic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      flash[:success] = 'Topic was successfully destroyed.'
      format.html { redirect_to cb_forum_url(@cb_forum) }
    end
  end

  private

    def setup
      @cb_forum = CbForum.find(params[:cb_forum_id])
      @body = "forum"
    end
end
