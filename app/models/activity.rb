# == Schema Information
# Schema version: 20080916002106
#
# Table name: activities
#
#  id         :integer(4)      not null, primary key
#  public     :boolean(1)      
#  item_id    :integer(4)      
#  person_id  :integer(4)      
#  item_type  :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Activity < ActiveRecord::Base
  belongs_to :person
  belongs_to :item, :polymorphic => true
  has_many :feeds, :dependent => :destroy
  
  GLOBAL_FEED_SIZE = 10

  # Return a feed drawn from all activities.
  # The fancy SQL is to keep inactive people out of feeds.
  # It's hard to do that entirely, but this way deactivated users 
  # won't be the person in "<person> has <done something>".
  #
  # This is especially useful for sites that require email verifications.
  # Their 'connected with admin' item won't show up until they verify.
  def self.global_feed
    find(:all, 
         :joins => "INNER JOIN people p ON activities.person_id = p.id",
         :conditions => [%(p.deactivated = ? AND
                           (p.email_verified IS NULL OR 
                            p.email_verified = ?)), 
                         false, true], 
         :order => 'activities.created_at DESC',
         :limit => GLOBAL_FEED_SIZE)
  end

    def activity_type
      self.item.class.to_s
    end

  def minifeed_without_links
    person = self.person
    case activity_type
    when "BlogPost"
      post = self.item
      blog = post.blog
      %(#{person.name.humanize} made a "new blog post - #{truncate(post.body)}")
    when "Comment"
      parent = self.item.commentable
      parent_type = parent.class.to_s
      case parent_type
      when "BlogPost"
        post = self.item.commentable
        blog = post.blog
        %(#{person.name.humanize} made a comment on #{blog.person.name.humanize}
          #{post.title})
      when "Person"
        %(#{self.item.commenter.name.humanize} commented on #{wall})
      when "Event"
        event = self.item.commentable
        %(#{self.item.commenter.name.humanize} commented on  #{event.person.name.humanize} )
      end
    when "Connection"
      if self.item.contact.admin?
        %(#{person.name.humanize} has joined the system)
      else
        %(#{person.name.humanize} and #{self.item.contact.name.humanize} have connected)
      end
    when "ForumPost"
      %(#{person.name.humanize} made a  forum post - #{self.item.title})
    when "Topic"
      %(#{person.name.humanize} created a  new discussion topic - #{self.item.name})
    when "Person"
      %(#{person.name.humanize}'s description changed)
    when "Gallery"
      %(#{person.name.humanize} added a new gallery
        titled as - #{self.item.title})
    when "Photo"
      %(#{person.name.humanize} added new photo to #{self.item.gallery.title})
      %(#{person.name.humanize}'s description has changed.)
    when "Event"
      %(#{person.name.humanize}'s has created a new event titled as - #{self.item.title})
    when "EventAttendee"
      event = self.item.event
      %(#{person.name.humanize} is attending #{event.person.name.humanize} the event - #{event.title})
    else
      %(Unrecognizable activity type)
      #raise "Invalid activity type #{activity_type(activity).inspect}"
    end
  end

   def wall
    commenter = self.person
    person = self.item.commentable
    "#{commenter.name.humanize}'s  wall"
  end
end
