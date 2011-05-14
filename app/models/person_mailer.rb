class PersonMailer < ActionMailer::Base
  extend PreferencesHelper
  
  def domain
    @domain ||= PersonMailer.global_prefs.domain
  end
  
  def server
    @server_name ||= PersonMailer.global_prefs.server_name
  end
  
  def password_reminder(person)
    from         "Password reminder <#{domain}>"
    recipients   person.email
    subject      formatted_subject("Password reminder")
    body         "person" => person
  end
 def contact_us(cust_name, cust_email, cust_message)
    @subject    = 'CentralBank Online: Contact'
    @body       = '<b>Sent By:</b> '+ cust_name + ' ['+ cust_email + ']<p>' + cust_message + '</p>'
    @recipients = "support@centralbanks.com"
    @from       = cust_email
    @sent_on    = Time.now
    @content_type = 'text/html'
    #@headers    = {}
  end
    def report_message(user,username,message)
    @subject    = 'CentralBank Online: compliant'
    @tempbody       = '<b>Sent By:</b> '+ user.name + ' ['+ user.email + ']'
    @username=username
    @message=message
    body[:content]=@tempbody
    body[:username]=@username
    body[:message]=@message
    @recipients = "bishop1213@yahoo.com"
    from         "User compaliant <#{domain}>"
    @sent_on    = Time.now
    @content_type = 'text/html'
   end


  def message_notification(message)
    from         "Message notification <#{domain}>"
    recipients   message.recipient.email
    subject      formatted_subject("New message")
    body          "message" => message,
                 "preferences_note" => preferences_note(message.recipient)
   @host ="http://cb.monkeypantsstudios.com"
   @name =message.recipient.name
   body[:host]=@host
   body[:name]=@name
  end
  
  def connection_request(connection)
    from         "Contact request <#{domain}>"
    recipients   connection.person.email
    subject      formatted_subject("Contact request from #{connection.contact.name}")
    @host ="http://cb.monkeypantsstudios.com"
   body[:host]=@host
   body[:connection]=connection
   body[:url] = "#{body[:host]}/login"
  end
  
  def blog_comment_notification(comment)
    from         "Comment notification <#{domain}>"
    recipients   comment.commented_person.email
    subject      formatted_subject("New blog comment")
    body         "server" => server, "comment" => comment,
                 "url" => 
    blog_post_path(comment.commentable.blog, comment.commentable),
                 "preferences_note" => 
    preferences_note(comment.commented_person)
  end
  
  def wall_comment_notification(comment)
    from         "Comment notification <#{domain}>"
    recipients   comment.commented_person.email
    subject      formatted_subject("New wall comment")
    body         "server" => server, "comment" => comment,
                 "url" => person_path(comment.commentable, :anchor => "wall"),
                 "preferences_note" => 
    preferences_note(comment.commented_person)
  end
  
  def email_verification(ev)
    from         "Email verification <#{domain}>"
    recipients   ev.person.email
    subject      formatted_subject("Email verification")
    body         "server_name" => server,
                 "code" => ev.code
  end
  def user_invitation(user,recipients,message,host)
    puts " *************************************** MAIL FUNCATION CALLED***********************************"
    from     user.email
    recipients recipients
    subject  formatted_subject("Your friend #{user.name} has invited you to join the central bank community {centralbank.com}.")
   @host ="http://cb.monkeypantsstudios.com/signup-selection"
   @message= message
   body[:host]=@host
   body[:name]=@name
   body[:message]=@message
   body[:user]=user
   body[:url] = "#{body[:host]}/?invitation_code=#{user.invitation_code}"
  end
  
  def user_activation(user)
    
    @host ="http://cb.monkeypantsstudios.com"
    @content_type = 'text/html'
    from     "Acount Activation <#{domain}>"
    recipients user.email
    subject  formatted_subject("Account Activation.")
    body   "Message" => user.name
    body[:host]=@host
    body[:user]=user
    body[:url] = "#{body[:host]}/login"
    
   end
  
  private
  
  # Prepend the application name to subjects if present in preferences.
  def formatted_subject(text)
    name = PersonMailer.global_prefs.app_name
    label = name.blank? ? "" : "[#{name}] "
      "#{label}#{text}"
  end
  
  def preferences_note(person)
      %(To change your email notification preferences, visit http://#{server}/people/#{person.to_param}/edit#email_prefs)
  end
end
