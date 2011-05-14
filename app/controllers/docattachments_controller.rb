class DocattachmentsController < ApplicationController
  # GET /docattachments
  # GET /docattachments.xml
  def index
    @docattachments = Docattachment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @docattachments }
    end
  end

  # GET /docattachments/1
  # GET /docattachments/1.xml
  def show
    @docattachment = Docattachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @docattachment }
    end
  end

  # GET /docattachments/new
  # GET /docattachments/new.xml
  def new
    @docattachment = Docattachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @docattachment }
    end
  end

  # GET /docattachments/1/edit
  def edit
    @docattachment = Docattachment.find(params[:id])
  end

  # POST /docattachments
  # POST /docattachments.xml
  def create
    @docattachment = Docattachment.new(params[:docattachment])

    respond_to do |format|
      if @docattachment.save
        flash[:notice] = 'Docattachment was successfully created.'
        format.html { redirect_to(@docattachment) }
        format.xml  { render :xml => @docattachment, :status => :created, :location => @docattachment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @docattachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /docattachments/1
  # PUT /docattachments/1.xml
  def update
    @docattachment = Docattachment.find(params[:id])

    respond_to do |format|
      if @docattachment.update_attributes(params[:docattachment])
        flash[:notice] = 'Docattachment was successfully updated.'
        format.html { redirect_to(@docattachment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @docattachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /docattachments/1
  # DELETE /docattachments/1.xml
  def destroy
    @docattachment = Docattachment.find(params[:id])
    @docattachment.destroy

    respond_to do |format|
      format.html { redirect_to(docattachments_url) }
      format.xml  { head :ok }
    end
  end
end
