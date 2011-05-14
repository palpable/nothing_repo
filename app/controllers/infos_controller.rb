class InfosController < ApplicationController
  
   def terms_of_use

  end
  def privacy_policy
    
  end
  def help
    
  end

  def contact_us
    if request.post?
    @name = params[:name]
    @email = params[:email]
    @email_message=params[:email_message]
     if params[:name].blank?
      flash[:error] = 'Name can not be blank'

       return
    elsif (params[:name]=~ /^([a-zA-Z])[-._a-zA-Z0-9]+$/).nil?
       flash[:error] = 'Name is Invalid'
      return

    end
    if params[:email].blank?
      flash[:error] = 'Email should not  be blank'
      return

    elsif (params[:email]=~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).nil?
       flash[:error] = 'Email is Invalid'
        return
    end
    if params[:email_message].blank?
      flash[:error] = 'Email Message should not be blank'
     return

    end
    mail = PersonMailer.deliver_contact_us(params[:name], params[:email], params[:email_message])

    flash[:notice] = 'Thank you for your request someone will get back to you within 48hrs'
    redirect_to(:action => 'contact_us')
    end

  end


end
