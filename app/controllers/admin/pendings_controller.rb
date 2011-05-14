class Admin::PendingsController < ApplicationController
  def index
     @pendings = Person.find_by_sql("select * from people where active=false and deactivated=false").paginate(:page => params[:page], :per_page =>10)
  end
def activate
    activated_ids = params[:active].collect {|id| id.to_i} if params[:active]
if activated_ids
 activated_ids.each do |a|
        @active = Person.find(a)
        @active.active = true
        if @active.save
          PersonMailer.deliver_user_activation(@active)
        end
  end
  flash[:success]="Users Successfully Activated"
    redirect_to :action=>"index"
else
  flash[:error]="Select atlease one people to activate"
    redirect_to :action=>"index"
end
end

end
