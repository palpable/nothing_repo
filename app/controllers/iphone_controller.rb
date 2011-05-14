class IphoneController < ApplicationController
  #protect_from_forgery :except => [ :login, :post_or_reply_message, :comment_on_wall_blog_or_event]
skip_before_filter :verify_authenticity_token

def login
  #if request.post?
    if  params.nil?
      return_failure(error_text_for_no_params)
    else
      email = params[:username]
      password = params[:password]

      person = Person.authenticate(email,password)
      if person.nil?
        return_failure(error_text_while_authentication)
      else
                 @xml = Builder::XmlMarkup.new
                 @user = Person.find(person.id)
              render :file => "iphone/all_xml.rxml"
      end #End of if person.nil?
    end #End of unless params.nil?
#  else
#    return_failure(error_text_for_get_requests)
#  end #End of if request.post
 end

  def post_or_reply_message
   # if request.post?
    unless  params.nil?
      email = params[:username]
      password = params[:password]

      person = Person.authenticate(email,password)
      if person.nil?
        return_failure(error_text_while_authentication)
      else
      recipient = Person.find_by_email(params[:recipient])
      subject = params[:subject]
      text_content = params[:content]
        if params[:parent].nil?
          message = Message.unsafe_build(:sender_id=>Person.find(person.id).id, :recipient_id=>recipient.id, :subject=>subject, :content=>text_content, :created_at=>Time.now, :updated_at=>Time.now)
        elsif !params[:parent].nil?
          parent_message=Message.find(params[:parent].to_i)
          message = Message.unsafe_build(:parent_id =>parent_message.id , :sender_id=>Person.find(person.id).id, :recipient_id=>recipient.id, :subject=>subject, :content=>text_content, :created_at=>Time.now, :updated_at=>Time.now)
        end
        if message.save!
          return_success
        else
          return_failure(error_text_while_message_post)
        end #End of message.save!
      end #End of if person.nil?

    end #End of unless params.nil?
#    else
#      return_failure(error_text_for_get_requests)
#    end #End of if request.post
  end #End of method post_or_reply_message

  def comment_on_wall_blog_or_event
   # if request.post?
    unless  params.nil?
      email = params[:username]
      password = params[:password]

      person = Person.authenticate(email,password)
      if person.nil?
        return_failure(error_text_while_authentication)
      else
      poster = Person.find(person.id)
      if wall?
          parent = Person.find(params[:person_id])
          type="Person"
          elsif blog?
            parent = Post.find(params[:blog_id])
            type="Post"
          elsif event?
            parent = Event.find(params[:event_id])
            type="Event"
      end
      body = params[:content]

        if parent.nil? or body.nil?
         return_failure(error_text_while_comment_post)
        elsif !parent.nil? and !body.nil?
          comment = Comment.unsafe_build(:commenter_id=>poster.id, :commentable_id=>parent.id, :commentable_type=>type, :body=>body, :created_at=>Time.now, :updated_at=>Time.now)
        end

        if comment.save!
       return_success
        end #End of message.save!
      end #End of if person.nil?

    end #End of unless params.nil?
#    else
#      return_failure(error_text_for_get_requests)
#    end #End of if requst.post
  end #End of method comment_on_wall_blog_or_event


   def wall?
      !params[:person_id].nil?
    end

    # True if resource lives in a blog.
    def blog?
      !params[:blog_id].nil?
    end

    def event?
      !params[:event_id].nil?
    end

    def return_failure(error_message=nil)
      if error_message.nil?
       result="<success value=\"false\"></success>"
      else
        result ="<success value=\"false\" error_message=\"#{error_message}\"></success>"
      end #End of if error_message.nil?
        render :xml => result, :layout=>false
    end #End of method return_failure

    def return_success
       result="<success value=\"true\"></success>"
        render :xml => result, :layout=>false
    end #End of method return_success

    def error_text_for_get_requests
      "Only POST requests, no GET request is allowed"
    end

    def error_text_while_authentication
      "Invalid Login credentials: No person found"
    end

    def error_text_while_message_post
      "Message/Reply not posted: recipient or body text not specified"
    end

    def error_text_while_comment_post
      "Comment not posted: No person/post/event or body specified"
    end

    def error_text_for_no_params
      "Invalid request: No parameters specified"
    end
end
