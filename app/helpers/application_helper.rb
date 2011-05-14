# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
   SORT_BY = Hash["Date" => "Date","People" => "People"]
  ## Application-wide values
  def app_name
    name = global_prefs.app_name
    default = "Central Banks"
    name.blank? ? default : name
  end
  
 def is_active?(page_name)
   puts" ****************************** is_active called ************************ #{page_name}"
     puts" ****************************** is_active called ************************ #{params[:action]}"
    "active" if params[:action] == page_name
  end



  ## Menu helpers
  
  def menu
    home     = menu_element("My Dashboard",   home_path)
    people   = menu_element("Member Profiles", people_path)
    resources = menu_element("Resources", "http://docs.insoshi.com/")
    
    about = menu_element("About Us", about_url)
    privacy = menu_element("Privacy Policy",:controller =>'infos',:action =>'privacy_policy')
    contact =  menu_element("Contact Us", :controller =>'infos',:action =>'contact_us')
    help    = menu_element("Help", home_path)
    terms_of_use = menu_element("Terms of Use",:controller =>'infos',:action =>'terms_of_use')

    if logged_in? and not admin_view?
      profile  = menu_element("My Profile",  person_path(current_person))
      messages = menu_element("My Messages", messages_path)
      fourms  =   menu_element("Forums",  forums_path)
      cb_forums = menu_element("CB-Forum",cb_forums_path)
      resources = menu_element("Resources",  resources_banks_path)
      roadshow = menu_element("Roadshow",   road_shows_path)
      events   = menu_element("Events", events_path)
      if current_person.isbanker != 0
      links = [home, profile, messages, people,fourms,cb_forums,resources,roadshow]
      else
       links = [home, profile, messages, people,fourms,resources,roadshow]
      end
     # links << roadshow if current_person.isbanker?
      #The above line is commend by palani by the instruction of Shawn becasue Non-central banker also have the option Roadshow
      
    elsif logged_in? and admin_view?
      home =    menu_element("Home", home_path)
      people =  menu_element("People", admin_people_path)
      preferences = menu_element("Prefs", admin_preferences_path)
      pendings = menu_element("Pendings", admin_pendings_path)
      news_feed= menu_element("News Feed",admin_news_feeds_path)
      links = [home, people, preferences,pendings,news_feed]
    else
     links = []
    end
    if global_prefs.about.blank?
      links
    else
      links.push(menu_element("About", about_url))
    end
  end

  def menu_element(content, address)
    { :content => content, :href => address }
  end
  
  def menu_link_to(link, options = {})
    content_tag(:span,link_to(link[:content], link[:href], options))
  end
  
  def menu_li(link, options = {})
    klass=""
    klass += "active" if current_page?(link[:href])
    content_tag(:li, menu_link_to(link, options), :class => klass)
  end
  
  def login_block
    forgot = global_prefs.can_send_email? ? '<br />' + link_to('I forgot my password', new_password_reminder_path) : ''
    content_tag(:span, link_to("Sign in", login_path) + ' or ' +
                       link_to("Sign up", signup_path) + 
                       forgot)
  end

  # Return true if the user is viewing the site in admin view.
  def admin_view?
    params[:controller] =~ /admin/ and admin?
  end
  
  def admin?
    logged_in? and current_person.admin?
  end
  
  # Set the input focus for a specific id
  # Usage: <%= set_focus_to 'form_field_label' %>
  def set_focus_to(id)
    javascript_tag(" $(document).ready(function(){$('##{id}').focus()});");
  end
  
  # Display text by sanitizing and formatting.
  # The html_options, if present, allow the syntax
  #  display("foo", :class => "bar")
  #  => '<p class="bar">foo</p>'
  def display(text, html_options = nil)
    begin
      if html_options
        html_options = html_options.stringify_keys
        tag_opts = tag_options(html_options)
      else
        tag_opts = nil
      end
      processed_text = format(sanitize(text))
    rescue
      # Sometimes Markdown throws exceptions, so rescue gracefully.
      processed_text = content_tag(:p, sanitize(text))
    end
    add_tag_options(processed_text, tag_opts)
  end
  
  # Output a column div.
  # The current two-column layout has primary & secondary columns.
  # The options hash is handled so that the caller can pass options to 
  # content_tag.
  # The LEFT, RIGHT, and FULL constants are defined in 
  # config/initializers/global_constants.rb
  def column_div(options = {}, &block)
    klass = options.delete(:type) == :primary ? "col1" : "col2"
    # Allow callers to pass in additional classes.
    options[:class] = "#{klass} #{options[:class]}".strip
    concat(content_tag(:div, capture(&block), options))
  end

  def email_link(person, options = {})
    reply = options[:replying_to]
    use_image = options[:use_image].nil? || options[:use_image]
    to_all = options[:to_all]
    if reply
      path = reply_message_path(reply)
    else
      path = new_person_message_path(person)
    end
    img = image_tag("icons/email_add.png")
    if reply.nil?
      action = to_all.nil? ? "Send Message" : "Message to Everyone"
    else
      action = "Send Reply"
    end
    opts = { :class => 'email-link' }
    if use_image
      str = link_to(action + ' ' + img, path, opts)
    else
      str = link_to_unless_current(action, path, opts)
    end
  end

  # Return a formatting note (depends on the presence of a Markdown library)
  def formatting_note
    if markdown?
      %(HTML and
        #{link_to("Markdown",
                  "http://daringfireball.net/projects/markdown/basics",
                  :popup => true)}
       formatting supported)
    else 
      "HTML formatting supported"
    end
  end

  def attachment_images(arg)
    case arg
    when 'image/jpeg'
      @img = "icon_JPG_small.gif"
    when 'image/bmp'
      @img = "icon_JPG_small.gif"
    when 'image/gif'
      @img = "icon_JPG_small.gif"
    when 'application/octet-stream'
      @img = "icon_MSW_small.jpeg"
    when 'text/plain'
      @img = "icon_TXT_small.jpeg"
    when 'application/pdf'
      @img = "icon_PDF_small.gif"
    when 'application/vnd.ms-excel'
      @img = "icon_XLS_small.gif"
    when 'application/msword'
      @img = "icon_MSW_small.jpeg"
    else
      @img = "icon_TXT_small.jpeg"
    end
  end

  private
  
    def inflect(word, number)
      number > 1 ? word.pluralize : word
    end
    
    def add_tag_options(text, options)
      text.gsub("<p>", "<p#{options}>")
    end
    
    # Format text using BlueCloth (or RDiscount) if available.
    def format(text)
      if text.nil?
        ""
      elsif defined?(RDiscount)
        RDiscount.new(text).to_html
      elsif defined?(BlueCloth)
        BlueCloth.new(text).to_html
      elsif no_paragraph_tag?(text)
        content_tag :p, text
      else
        text
      end
    end
    
    def sort_by
     
      @sort_by=SORT_BY
      return @sort_by
      
    end
    # Is a Markdown library present?
    def markdown?
      defined?(RDiscount) or defined?(BlueCloth)
    end
    
    # Return true if the text *doesn't* start with a paragraph tag.
    def no_paragraph_tag?(text)
      text !~ /^\<p/
    end
end
